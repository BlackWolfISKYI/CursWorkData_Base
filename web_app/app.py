"""
Flask веб-додаток для інтернет-магазину страйкбольного обладнання
Курсова робота з дисципліни "Бази даних"
"""

from flask import Flask, render_template, request, redirect, url_for, flash, jsonify, session
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
import pyodbc
from datetime import datetime
from functools import wraps
import hashlib
import os

app = Flask(__name__)
app.secret_key = os.urandom(24)

# Конфігурація бази даних
DB_CONFIG = {
    'driver': 'ODBC Driver 17 for SQL Server',
    'server': '(localdb)\\MSSQLLocalDB',
    'database': 'airsoft_shop',
    'trusted_connection': 'yes'
}

# Flask-Login налаштування
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

# ================================================
# DATABASE CONNECTION
# ================================================

def get_db_connection():
    """Створення підключення до бази даних"""
    try:
        connection_string = (
            f"DRIVER={{{DB_CONFIG['driver']}}};"
            f"SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};"
            f"Trusted_Connection={DB_CONFIG['trusted_connection']};"
            f"Encrypt=no;"
        )
        return pyodbc.connect(connection_string)
    except pyodbc.Error as e:
        print(f"Помилка підключення до БД: {e}")
        return None

# ================================================
# USER MODEL
# ================================================

class User(UserMixin):
    def __init__(self, user_id, email, first_name, last_name, role_id):
        self.id = user_id
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.role_id = role_id
    
    @property
    def is_admin(self):
        return self.role_id == 1
    
    @property
    def is_manager(self):
        return self.role_id == 3

@login_manager.user_loader
def load_user(user_id):
    conn = get_db_connection()
    if not conn:
        return None
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT UserID, Email, FirstName, LastName, RoleID
        FROM Users
        WHERE UserID = ? AND IsActive = 1
    """, user_id)
    
    row = cursor.fetchone()
    conn.close()
    
    if row:
        return User(row[0], row[1], row[2], row[3], row[4])
    return None

def admin_required(f):
    @wraps(f)
    @login_required
    def decorated_function(*args, **kwargs):
        if not current_user.is_admin:
            flash('Доступ заборонено. Потрібні права адміністратора.', 'danger')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function

# ================================================
# ROUTES - Головна сторінка
# ================================================

@app.route('/')
def index():
    """Головна сторінка з товарами"""
    conn = get_db_connection()
    if not conn:
        flash('Помилка підключення до бази даних', 'danger')
        return render_template('error.html')
    
    cursor = conn.cursor()
    
    # Отримання популярних товарів
    cursor.execute("""
        SELECT TOP 8
            p.ProductID, p.ProductName, p.Brand, p.Model, 
            p.Price, p.Discount, p.ImageURL, c.CategoryName,
            ROUND(p.Price * (1 - p.Discount / 100), 2) AS FinalPrice
        FROM Products p
        INNER JOIN Categories c ON p.CategoryID = c.CategoryID
        WHERE p.IsActive = 1 AND p.IsFeatured = 1
        ORDER BY p.CreatedAt DESC
    """)
    
    featured_products = cursor.fetchall()
    
    # Отримання категорій
    cursor.execute("""
        SELECT CategoryID, CategoryName, Description
        FROM Categories
        WHERE ParentCategoryID IS NULL
    """)
    categories = cursor.fetchall()
    
    conn.close()
    
    return render_template('index.html', 
                         featured_products=featured_products,
                         categories=categories)

# ================================================
# ROUTES - Каталог товарів
# ================================================

@app.route('/catalog')
def catalog():
    """Каталог всіх товарів з фільтрацією"""
    conn = get_db_connection()
    if not conn:
        flash('Помилка підключення до бази даних', 'danger')
        return redirect(url_for('index'))
    
    # Отримання параметрів фільтрації
    category_id = request.args.get('category', type=int)
    min_price = request.args.get('min_price', type=float)
    max_price = request.args.get('max_price', type=float)
    search = request.args.get('search', '')
    
    cursor = conn.cursor()
    
    # Базовий запит
    query = """
        SELECT 
            p.ProductID, p.ProductName, p.Brand, p.Model, 
            p.Price, p.Discount, p.ImageURL, c.CategoryName,
            p.StockQuantity,
            ROUND(p.Price * (1 - p.Discount / 100), 2) AS FinalPrice
        FROM Products p
        INNER JOIN Categories c ON p.CategoryID = c.CategoryID
        WHERE p.IsActive = 1
    """
    params = []
    
    # Додавання фільтрів
    if category_id:
        query += " AND p.CategoryID = ?"
        params.append(category_id)
    
    if min_price:
        query += " AND p.Price >= ?"
        params.append(min_price)
    
    if max_price:
        query += " AND p.Price <= ?"
        params.append(max_price)
    
    if search:
        query += " AND (p.ProductName LIKE ? OR p.Brand LIKE ? OR p.Model LIKE ?)"
        search_term = f'%{search}%'
        params.extend([search_term, search_term, search_term])
    
    query += " ORDER BY p.ProductName"
    
    cursor.execute(query, params)
    products = cursor.fetchall()
    
    # Отримання всіх категорій для фільтру
    cursor.execute("""
        SELECT CategoryID, CategoryName
        FROM Categories
        WHERE ParentCategoryID IS NOT NULL
        ORDER BY CategoryName
    """)
    categories = cursor.fetchall()
    
    conn.close()
    
    return render_template('catalog.html', 
                         products=products,
                         categories=categories,
                         selected_category=category_id)

# ================================================
# ROUTES - Деталі товару
# ================================================

@app.route('/product/<int:product_id>')
def product_detail(product_id):
    """Детальна інформація про товар"""
    conn = get_db_connection()
    if not conn:
        flash('Помилка підключення до бази даних', 'danger')
        return redirect(url_for('catalog'))
    
    cursor = conn.cursor()
    
    # Отримання інформації про товар
    cursor.execute("""
        SELECT 
            p.ProductID, p.ProductName, p.Brand, p.Model, p.Description,
            p.Caliber, p.FPS, p.Magazine, p.PowerSource, p.Material,
            p.Weight, p.Length, p.Color, p.Price, p.Discount, 
            p.StockQuantity, p.ImageURL, c.CategoryName, s.SupplierName,
            ROUND(p.Price * (1 - p.Discount / 100), 2) AS FinalPrice
        FROM Products p
        INNER JOIN Categories c ON p.CategoryID = c.CategoryID
        LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
        WHERE p.ProductID = ? AND p.IsActive = 1
    """, product_id)
    
    product = cursor.fetchone()
    
    if not product:
        conn.close()
        flash('Товар не знайдено', 'warning')
        return redirect(url_for('catalog'))
    
    # Отримання відгуків
    cursor.execute("""
        SELECT 
            r.ReviewID, r.Rating, r.Title, r.Comment, r.CreatedAt,
            u.FirstName, u.LastName, r.IsVerifiedPurchase
        FROM Reviews r
        INNER JOIN Users u ON r.UserID = u.UserID
        WHERE r.ProductID = ? AND r.IsPublished = 1
        ORDER BY r.CreatedAt DESC
    """, product_id)
    
    reviews = cursor.fetchall()
    
    # Середній рейтинг
    cursor.execute("""
        SELECT 
            COUNT(*) AS ReviewCount,
            ROUND(AVG(CAST(Rating AS FLOAT)), 1) AS AvgRating
        FROM Reviews
        WHERE ProductID = ? AND IsPublished = 1
    """, product_id)
    
    rating_info = cursor.fetchone()
    
    conn.close()
    
    return render_template('product_detail.html',
                         product=product,
                         reviews=reviews,
                         rating_info=rating_info)

# ================================================
# ROUTES - Кошик
# ================================================

@app.route('/cart')
@login_required
def cart():
    """Перегляд кошика"""
    conn = get_db_connection()
    if not conn:
        flash('Помилка підключення до бази даних', 'danger')
        return redirect(url_for('index'))
    
    cursor = conn.cursor()
    
    cursor.execute("""
        SELECT 
            c.CartID, c.Quantity, p.ProductID, p.ProductName, 
            p.Brand, p.Price, p.Discount, p.ImageURL,
            ROUND(p.Price * (1 - p.Discount / 100), 2) AS UnitPrice,
            ROUND(p.Price * (1 - p.Discount / 100) * c.Quantity, 2) AS TotalPrice
        FROM Cart c
        INNER JOIN Products p ON c.ProductID = p.ProductID
        WHERE c.UserID = ?
    """, current_user.id)
    
    cart_items = cursor.fetchall()
    
    # Розрахунок загальної вартості
    total = sum(item[9] for item in cart_items) if cart_items else 0
    
    conn.close()
    
    return render_template('cart.html', cart_items=cart_items, total=total)

@app.route('/cart/add/<int:product_id>', methods=['POST'])
@login_required
def add_to_cart(product_id):
    """Додавання товару в кошик"""
    quantity = request.form.get('quantity', 1, type=int)
    
    conn = get_db_connection()
    if not conn:
        flash('Помилка підключення до бази даних', 'danger')
        return redirect(url_for('product_detail', product_id=product_id))
    
    cursor = conn.cursor()
    
    try:
        # Перевірка наявності на складі
        cursor.execute("SELECT StockQuantity FROM Products WHERE ProductID = ?", product_id)
        stock = cursor.fetchone()
        
        if not stock or stock[0] < quantity:
            flash('Недостатньо товару на складі', 'warning')
            conn.close()
            return redirect(url_for('product_detail', product_id=product_id))
        
        # Додавання в кошик (або оновлення кількості)
        cursor.execute("""
            MERGE Cart AS target
            USING (SELECT ? AS UserID, ? AS ProductID, ? AS Quantity) AS source
            ON target.UserID = source.UserID AND target.ProductID = source.ProductID
            WHEN MATCHED THEN
                UPDATE SET Quantity = target.Quantity + source.Quantity
            WHEN NOT MATCHED THEN
                INSERT (UserID, ProductID, Quantity) 
                VALUES (source.UserID, source.ProductID, source.Quantity);
        """, current_user.id, product_id, quantity)
        
        conn.commit()
        flash('Товар додано в кошик!', 'success')
        
    except pyodbc.Error as e:
        flash(f'Помилка: {e}', 'danger')
    
    conn.close()
    return redirect(url_for('product_detail', product_id=product_id))

@app.route('/cart/remove/<int:cart_id>', methods=['POST'])
@login_required
def remove_from_cart(cart_id):
    """Видалення товару з кошика"""
    conn = get_db_connection()
    if not conn:
        flash('Помилка підключення до бази даних', 'danger')
        return redirect(url_for('cart'))
    
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Cart WHERE CartID = ? AND UserID = ?", 
                  cart_id, current_user.id)
    conn.commit()
    conn.close()
    
    flash('Товар видалено з кошика', 'info')
    return redirect(url_for('cart'))

# ================================================
# ROUTES - Авторизація
# ================================================

@app.route('/login', methods=['GET', 'POST'])
def login():
    """Авторизація користувача"""
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        
        # Хешування пароля (простий варіант для демонстрації)
        password_hash = hashlib.sha256(password.encode()).hexdigest()
        
        conn = get_db_connection()
        if not conn:
            flash('Помилка підключення до бази даних', 'danger')
            return render_template('login.html')
        
        cursor = conn.cursor()
        cursor.execute("""
            SELECT UserID, Email, FirstName, LastName, RoleID
            FROM Users
            WHERE Email = ? AND IsActive = 1
        """, email)
        
        user_data = cursor.fetchone()
        conn.close()
        
        if user_data:
            user = User(user_data[0], user_data[1], user_data[2], user_data[3], user_data[4])
            login_user(user)
            flash(f'Ласкаво просимо, {user.first_name}!', 'success')
            return redirect(url_for('index'))
        else:
            flash('Невірний email або пароль', 'danger')
    
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    """Вихід з системи"""
    logout_user()
    flash('Ви успішно вийшли з системи', 'info')
    return redirect(url_for('index'))

# ================================================
# ROUTES - Адмін панель
# ================================================

@app.route('/admin')
@admin_required
def admin_panel():
    """Панель адміністратора"""
    conn = get_db_connection()
    if not conn:
        flash('Помилка підключення до бази даних', 'danger')
        return redirect(url_for('index'))
    
    cursor = conn.cursor()
    
    # Статистика
    cursor.execute("SELECT COUNT(*) FROM Products WHERE IsActive = 1")
    products_count = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM Users WHERE IsActive = 1")
    users_count = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM Orders")
    orders_count = cursor.fetchone()[0]
    
    cursor.execute("SELECT SUM(TotalAmount) FROM Orders WHERE Status = 'Delivered'")
    revenue = cursor.fetchone()[0] or 0
    
    conn.close()
    
    return render_template('admin/dashboard.html',
                         products_count=products_count,
                         users_count=users_count,
                         orders_count=orders_count,
                         revenue=revenue)

@app.route('/admin/products')
@admin_required
def admin_products():
    """Управління товарами"""
    conn = get_db_connection()
    if not conn:
        flash('Помилка підключення до бази даних', 'danger')
        return redirect(url_for('admin_panel'))
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            p.ProductID, p.ProductName, p.Brand, p.Price, 
            p.StockQuantity, c.CategoryName, p.IsActive
        FROM Products p
        INNER JOIN Categories c ON p.CategoryID = c.CategoryID
        ORDER BY p.ProductName
    """)
    
    products = cursor.fetchall()
    conn.close()
    
    return render_template('admin/products.html', products=products)

# ================================================
# API ENDPOINTS
# ================================================

@app.route('/api/products/search')
def api_search_products():
    """API для пошуку товарів"""
    search = request.args.get('q', '')
    
    if len(search) < 2:
        return jsonify([])
    
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT TOP 10
            ProductID, ProductName, Brand, Price
        FROM Products
        WHERE (ProductName LIKE ? OR Brand LIKE ?) AND IsActive = 1
    """, f'%{search}%', f'%{search}%')
    
    results = cursor.fetchall()
    conn.close()
    
    products = [
        {
            'id': row[0],
            'name': row[1],
            'brand': row[2],
            'price': float(row[3])
        }
        for row in results
    ]
    
    return jsonify(products)

# ================================================
# ERROR HANDLERS
# ================================================

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404

@app.errorhandler(500)
def internal_error(e):
    return render_template('500.html'), 500

# ================================================
# MAIN
# ================================================

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
