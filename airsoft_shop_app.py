"""
Демонстраційний додаток для роботи з базою даних
інтернет-магазину страйкбольного обладнання

Курсова робота з дисципліни "Бази даних"
"""

import pyodbc
from datetime import datetime
from typing import Optional, List, Tuple
import getpass


class AirSoftShopDB:
    """Клас для роботи з базою даних інтернет-магазину"""
    
    def __init__(self, server: str, database: str, user: str, password: str, driver: str = 'ODBC Driver 17 for SQL Server'):
        """
        Ініціалізація підключення до БД
        
        Args:
            server: Адреса сервера БД (наприклад, 'localhost' або '127.0.0.1')
            database: Назва бази даних
            user: Ім'я користувача
            password: Пароль
            driver: ODBC драйвер для SQL Server
        """
        self.server = server
        self.database = database
        self.user = user
        self.password = password
        self.driver = driver
        self.connection = None
        
    def connect(self) -> bool:
        """Встановлення з'єднання з БД"""
        try:
            connection_string = (
                f'DRIVER={{{self.driver}}};'
                f'SERVER={self.server};'
                f'DATABASE={self.database};'
                f'UID={self.user};'
                f'PWD={self.password};'
                f'Encrypt=no;'
                f'TrustServerCertificate=yes;'
            )
            self.connection = pyodbc.connect(connection_string)
            print(f"✓ Успішно підключено до БД '{self.database}'")
            return True
        except pyodbc.Error as e:
            print(f"✗ Помилка підключення до БД: {e}")
            return False
    
    def disconnect(self):
        """Закриття з'єднання з БД"""
        if self.connection:
            self.connection.close()
            print("✓ З'єднання з БД закрито")
    
    def execute_query(self, query: str, params: tuple = None) -> bool:
        """
        Виконання запиту INSERT, UPDATE, DELETE
        
        Args:
            query: SQL запит
            params: Параметри запиту
            
        Returns:
            True якщо успішно, False якщо помилка
        """
        cursor = self.connection.cursor()
        try:
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            self.connection.commit()
            print(f"✓ Запит виконано успішно. Оброблено рядків: {cursor.rowcount}")
            return True
        except pyodbc.Error as e:
            print(f"✗ Помилка виконання запиту: {e}")
            return False
        finally:
            cursor.close()
    
    def fetch_query(self, query: str, params: tuple = None) -> Optional[List[Tuple]]:
        """
        Виконання запиту SELECT
        
        Args:
            query: SQL запит
            params: Параметри запиту
            
        Returns:
            Список кортежів з результатами або None
        """
        cursor = self.connection.cursor()
        try:
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            results = cursor.fetchall()
            return results
        except pyodbc.Error as e:
            print(f"✗ Помилка виконання запиту: {e}")
            return None
        finally:
            cursor.close()
    
    # ==========================================
    # МЕТОДИ ДЛЯ РОБОТИ З ТОВАРАМИ
    # ==========================================
    
    def get_all_products(self):
        """Отримати список всіх товарів"""
        query = """
        SELECT 
            p.ProductID,
            p.ProductName,
            c.CategoryName,
            p.Brand,
            p.Price,
            p.Discount,
            ROUND(p.Price * (1 - p.Discount / 100), 2) AS FinalPrice,
            p.StockQuantity
        FROM Products p
        LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
        WHERE p.IsActive = 1
        ORDER BY p.ProductName
        """
        results = self.fetch_query(query)
        
        if results:
            print("\n" + "="*120)
            print(f"{'ID':<5} {'Назва товару':<40} {'Категорія':<20} {'Бренд':<15} {'Ціна':<10} {'Знижка':<8} {'Остат.':<7}")
            print("="*120)
            for row in results:
                pid, name, cat, brand, price, disc, final, stock = row
                discount_str = f"{disc}%" if disc > 0 else "-"
                print(f"{pid:<5} {name:<40} {cat:<20} {brand:<15} {final:<10.2f} {discount_str:<8} {stock:<7}")
            print("="*120)
            print(f"Всього товарів: {len(results)}\n")
        else:
            print("Товари не знайдені")
    
    def search_products(self, search_term: str):
        """Пошук товарів за назвою або брендом"""
        query = """
        SELECT 
            p.ProductID,
            p.ProductName,
            c.CategoryName,
            p.Brand,
            ROUND(p.Price * (1 - p.Discount / 100), 2) AS FinalPrice,
            p.StockQuantity
        FROM Products p
        LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
        WHERE p.IsActive = 1
            AND (p.ProductName LIKE ? OR p.Brand LIKE ?)
        ORDER BY p.ProductName
        """
        search_pattern = f"%{search_term}%"
        results = self.fetch_query(query, (search_pattern, search_pattern))
        
        if results:
            print(f"\nЗнайдено товарів: {len(results)}")
            print("-"*100)
            for row in results:
                pid, name, cat, brand, price, stock = row
                print(f"ID: {pid} | {name} ({brand})")
                print(f"   Категорія: {cat} | Ціна: {price:.2f} грн | Залишок: {stock} шт.")
                print("-"*100)
        else:
            print(f"Товари за запитом '{search_term}' не знайдені")
    
    def get_product_by_id(self, product_id: int):
        """Отримати детальну інформацію про товар"""
        query = """
        SELECT 
            p.ProductID,
            p.ProductName,
            c.CategoryName,
            s.SupplierName,
            p.Brand,
            p.Model,
            p.Description,
            p.Price,
            p.Discount,
            ROUND(p.Price * (1 - p.Discount / 100), 2) AS FinalPrice,
            p.StockQuantity,
            COALESCE(AVG(CAST(r.Rating AS FLOAT)), 0) AS AvgRating,
            COUNT(r.ReviewID) AS ReviewCount
        FROM Products p
        LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
        LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
        LEFT JOIN Reviews r ON p.ProductID = r.ProductID
        WHERE p.ProductID = ?
        GROUP BY p.ProductID, p.ProductName, c.CategoryName, s.SupplierName, p.Brand, 
                 p.Model, p.Description, p.Price, p.Discount, p.StockQuantity
        """
        results = self.fetch_query(query, (product_id,))
        
        if results:
            row = results[0]
            print("\n" + "="*80)
            print(f"ID: {row[0]}")
            print(f"Назва: {row[1]}")
            print(f"Категорія: {row[2]}")
            print(f"Постачальник: {row[3]}")
            print(f"Бренд: {row[4]}")
            print(f"Модель: {row[5]}")
            print(f"Опис: {row[6]}")
            print(f"Ціна: {row[7]:.2f} грн")
            if row[8] > 0:
                print(f"Знижка: {row[8]}%")
                print(f"Ціна зі знижкою: {row[9]:.2f} грн")
            print(f"Залишок на складі: {row[10]} шт.")
            print(f"Рейтинг: {row[11]:.1f}/5 ({row[12]} відгуків)")
            print("="*80 + "\n")
        else:
            print(f"Товар з ID {product_id} не знайдено")
    
    def add_product(self, name: str, category_id: int, supplier_id: int, 
                   brand: str, price: float, stock: int, description: str = ""):
        """Додати новий товар"""
        query = """
        INSERT INTO Products 
        (ProductName, CategoryID, SupplierID, Brand, Price, StockQuantity, Description)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """
        params = (name, category_id, supplier_id, brand, price, stock, description)
        return self.execute_query(query, params)
    
    def update_product_price(self, product_id: int, new_price: float):
        """Оновити ціну товару"""
        query = "UPDATE Products SET Price = ? WHERE ProductID = ?"
        return self.execute_query(query, (new_price, product_id))
    
    def set_product_discount(self, product_id: int, discount: float):
        """Встановити знижку на товар"""
        query = "UPDATE Products SET Discount = ? WHERE ProductID = ?"
        return self.execute_query(query, (discount, product_id))
    
    # ==========================================
    # МЕТОДИ ДЛЯ РОБОТИ З КОРИСТУВАЧАМИ
    # ==========================================
    
    def get_all_users(self):
        """Отримати список всіх користувачів"""
        query = """
        SELECT 
            u.UserID,
            u.FirstName,
            u.LastName,
            u.Email,
            u.Phone,
            u.City,
            r.RoleName,
            u.RegisteredAt
        FROM Users u
        LEFT JOIN UserRoles r ON u.RoleID = r.RoleID
        WHERE u.IsActive = 1
        ORDER BY u.RegisteredAt DESC
        """
        results = self.fetch_query(query)
        
        if results:
            print("\n" + "="*100)
            print(f"{'ID':<5} {'Ім\'я':<15} {'Прізвище':<15} {'Email':<30} {'Місто':<15} {'Роль':<10}")
            print("="*100)
            for row in results:
                print(f"{row[0]:<5} {row[1]:<15} {row[2]:<15} {row[3]:<30} {row[5]:<15} {row[6]:<10}")
            print("="*100)
            print(f"Всього користувачів: {len(results)}\n")
        else:
            print("Користувачі не знайдені")
    
    # ==========================================
    # МЕТОДИ ДЛЯ РОБОТИ З ЗАМОВЛЕННЯМИ
    # ==========================================
    
    def get_user_orders(self, user_id: int):
        """Отримати замовлення користувача"""
        query = """
        SELECT 
            o.OrderID,
            o.OrderDate,
            o.Status,
            o.TotalAmount,
            o.PaymentStatus,
            COUNT(od.OrderDetailID) AS ItemCount
        FROM Orders o
        LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
        WHERE o.UserID = ?
        GROUP BY o.OrderID, o.OrderDate, o.Status, o.TotalAmount, o.PaymentStatus
        ORDER BY o.OrderDate DESC
        """
        results = self.fetch_query(query, (user_id,))
        
        if results:
            print(f"\nЗамовлення користувача ID {user_id}:")
            print("="*90)
            print(f"{'ID':<8} {'Дата':<20} {'Статус':<15} {'Сума':<12} {'Оплата':<15} {'Товарів':<8}")
            print("="*90)
            for row in results:
                print(f"{row[0]:<8} {str(row[1]):<20} {row[2]:<15} {row[3]:<12.2f} {row[4]:<15} {row[5]:<8}")
            print("="*90 + "\n")
        else:
            print(f"Замовлення для користувача {user_id} не знайдені")
    
    def get_order_details(self, order_id: int):
        """Отримати деталі замовлення"""
        query = """
        SELECT 
            p.ProductName,
            od.Quantity,
            od.UnitPrice,
            od.Discount,
            od.TotalPrice
        FROM OrderDetails od
        INNER JOIN Products p ON od.ProductID = p.ProductID
        WHERE od.OrderID = ?
        """
        results = self.fetch_query(query, (order_id,))
        
        if results:
            print(f"\nДеталі замовлення #{order_id}:")
            print("="*100)
            print(f"{'Товар':<50} {'Кількість':<12} {'Ціна':<12} {'Знижка':<10} {'Сума':<12}")
            print("="*100)
            total = 0
            for row in results:
                print(f"{row[0]:<50} {row[1]:<12} {row[2]:<12.2f} {row[3]:<10}% {row[4]:<12.2f}")
                total += row[4]
            print("="*100)
            print(f"{'РАЗОМ:':<74} {total:.2f} грн\n")
        else:
            print(f"Деталі для замовлення {order_id} не знайдені")
    
    # ==========================================
    # МЕТОДИ ДЛЯ РОБОТИ З КОШИКОМ
    # ==========================================
    
    def get_cart(self, user_id: int):
        """Отримати вміст кошика користувача"""
        query = """
        SELECT 
            c.CartID,
            p.ProductName,
            p.Brand,
            p.Price,
            p.Discount,
            c.Quantity,
            ROUND(p.Price * (1 - p.Discount / 100) * c.Quantity, 2) AS TotalPrice
        FROM Cart c
        INNER JOIN Products p ON c.ProductID = p.ProductID
        WHERE c.UserID = ?
        """
        results = self.fetch_query(query, (user_id,))
        
        if results:
            print(f"\nКошик користувача ID {user_id}:")
            print("="*100)
            print(f"{'Товар':<40} {'Бренд':<15} {'Ціна':<12} {'К-сть':<8} {'Сума':<12}")
            print("="*100)
            total = 0
            for row in results:
                print(f"{row[1]:<40} {row[2]:<15} {row[3]:<12.2f} {row[5]:<8} {row[6]:<12.2f}")
                total += row[6]
            print("="*100)
            print(f"{'РАЗОМ:':<75} {total:.2f} грн\n")
        else:
            print(f"Кошик порожній")
    
    def add_to_cart(self, user_id: int, product_id: int, quantity: int = 1):
        """Додати товар до кошика"""
        query = """
        MERGE Cart AS target
        USING (SELECT ? AS UserID, ? AS ProductID, ? AS Quantity) AS src
            ON target.UserID = src.UserID AND target.ProductID = src.ProductID
        WHEN MATCHED THEN
            UPDATE SET Quantity = target.Quantity + src.Quantity
        WHEN NOT MATCHED THEN
            INSERT (UserID, ProductID, Quantity) VALUES (src.UserID, src.ProductID, src.Quantity);
        """
        return self.execute_query(query, (user_id, product_id, quantity))
    
    # ==========================================
    # АНАЛІТИЧНІ МЕТОДИ
    # ==========================================
    
    def get_sales_statistics(self):
        """Отримати статистику продажів"""
        query = """
        SELECT 
            c.CategoryName,
            COUNT(DISTINCT od.OrderID) AS OrderCount,
            SUM(od.Quantity) AS TotalItemsSold,
            ROUND(SUM(od.TotalPrice), 2) AS TotalRevenue
        FROM Categories c
        INNER JOIN Products p ON c.CategoryID = p.CategoryID
        INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
        GROUP BY c.CategoryID, c.CategoryName
        ORDER BY TotalRevenue DESC
        """
        results = self.fetch_query(query)
        
        if results:
            print("\nСтатистика продажів по категоріях:")
            print("="*90)
            print(f"{'Категорія':<25} {'Замовлень':<15} {'Продано од.':<15} {'Виручка (грн)':<20}")
            print("="*90)
            for row in results:
                print(f"{row[0]:<25} {row[1]:<15} {row[2]:<15} {row[3]:<20.2f}")
            print("="*90 + "\n")
        else:
            print("Статистика відсутня")
    
    def get_top_products(self, limit: int = 10):
        """Отримати топ найпопулярніших товарів"""
        query = f"""
        SELECT TOP {limit}
            p.ProductName,
            p.Brand,
            SUM(od.Quantity) AS TotalSold,
            ROUND(SUM(od.TotalPrice), 2) AS Revenue
        FROM Products p
        INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
        GROUP BY p.ProductID, p.ProductName, p.Brand
        ORDER BY TotalSold DESC
        """
        results = self.fetch_query(query)
        
        if results:
            print(f"\nТоп-{limit} найпопулярніших товарів:")
            print("="*100)
            print(f"{'#':<5} {'Товар':<45} {'Бренд':<15} {'Продано':<12} {'Виручка':<15}")
            print("="*100)
            for idx, row in enumerate(results, 1):
                print(f"{idx:<5} {row[0]:<45} {row[1]:<15} {row[2]:<12} {row[3]:<15.2f}")
            print("="*100 + "\n")
        else:
            print("Дані відсутні")


# ==========================================
# ІНТЕРАКТИВНЕ МЕНЮ
# ==========================================

def print_menu():
    """Вивести головне меню"""
    print("\n" + "="*60)
    print(" ІНТЕРНЕТ-МАГАЗИН СТРАЙКБОЛЬНОГО ОБЛАДНАННЯ")
    print("="*60)
    print("1.  Переглянути всі товари")
    print("2.  Пошук товарів")
    print("3.  Інформація про товар")
    print("4.  Додати товар")
    print("5.  Оновити ціну товару")
    print("6.  Встановити знижку на товар")
    print("7.  Переглянути всіх користувачів")
    print("8.  Замовлення користувача")
    print("9.  Деталі замовлення")
    print("10. Переглянути кошик")
    print("11. Додати товар до кошика")
    print("12. Статистика продажів")
    print("13. Топ популярних товарів")
    print("0.  Вихід")
    print("="*60)


def main():
    """Головна функція програми"""
    print("\n╔════════════════════════════════════════════════════════════╗")
    print("║ База даних інтернет-магазину страйкбольного обладнання   ║")
    print("║ Курсова робота з дисципліни 'Бази даних'                 ║")
    print("╚════════════════════════════════════════════════════════════╝\n")
    
    # Підключення до БД
    print("Введіть параметри підключення до SQL Server:")
    server = input("Server (за замовчуванням: (localdb)\\MSSQLLocalDB): ").strip() or "(localdb)\\MSSQLLocalDB"
    database = input("Назва БД (за замовчуванням: airsoft_shop): ").strip() or "airsoft_shop"
    user = input("Користувач (за замовчуванням: sa): ").strip() or "sa"
    password = getpass.getpass("Пароль: ")
    
    db = AirSoftShopDB(server, database, user, password)
    
    if not db.connect():
        print("Не вдалося підключитися до БД. Програма завершена.")
        return
    
    # Головний цикл програми
    while True:
        print_menu()
        choice = input("Оберіть опцію: ").strip()
        
        if choice == "1":
            db.get_all_products()
        
        elif choice == "2":
            search_term = input("Введіть назву або бренд для пошуку: ").strip()
            db.search_products(search_term)
        
        elif choice == "3":
            product_id = int(input("Введіть ID товару: "))
            db.get_product_by_id(product_id)
        
        elif choice == "4":
            print("\nДодавання нового товару:")
            name = input("Назва: ")
            category_id = int(input("ID категорії: "))
            supplier_id = int(input("ID постачальника: "))
            brand = input("Бренд: ")
            price = float(input("Ціна: "))
            stock = int(input("Кількість на складі: "))
            description = input("Опис (необов'язково): ")
            db.add_product(name, category_id, supplier_id, brand, price, stock, description)
        
        elif choice == "5":
            product_id = int(input("ID товару: "))
            new_price = float(input("Нова ціна: "))
            db.update_product_price(product_id, new_price)
        
        elif choice == "6":
            product_id = int(input("ID товару: "))
            discount = float(input("Знижка (%): "))
            db.set_product_discount(product_id, discount)
        
        elif choice == "7":
            db.get_all_users()
        
        elif choice == "8":
            user_id = int(input("ID користувача: "))
            db.get_user_orders(user_id)
        
        elif choice == "9":
            order_id = int(input("ID замовлення: "))
            db.get_order_details(order_id)
        
        elif choice == "10":
            user_id = int(input("ID користувача: "))
            db.get_cart(user_id)
        
        elif choice == "11":
            user_id = int(input("ID користувача: "))
            product_id = int(input("ID товару: "))
            quantity = int(input("Кількість: "))
            db.add_to_cart(user_id, product_id, quantity)
        
        elif choice == "12":
            db.get_sales_statistics()
        
        elif choice == "13":
            limit = int(input("Скільки товарів показати (за замовчуванням 10): ") or "10")
            db.get_top_products(limit)
        
        elif choice == "0":
            print("\nДякуємо за використання програми!")
            break
        
        else:
            print("Невірна опція. Спробуйте ще раз.")
        
        input("\nНатисніть Enter для продовження...")
    
    db.disconnect()


if __name__ == "__main__":
    main()
