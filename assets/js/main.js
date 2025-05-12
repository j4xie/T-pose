// T-Order POS 主要JavaScript
document.addEventListener('alpine:init', () => {
  // 全局状态管理
  Alpine.store('app', {
    currentUser: null,
    currentShift: null,
    currentTime: new Date().toLocaleTimeString(),
    isNetworkConnected: true,
    isPrinterConnected: true,
    
    init() {
      // 更新时间
      setInterval(() => {
        this.currentTime = new Date().toLocaleTimeString();
      }, 1000);
    },
    
    login(username, password) {
      // 模拟登录逻辑
      if (username && password) {
        this.currentUser = {
          name: username,
          role: '收银员',
          avatar: 'https://source.unsplash.com/random/100x100/?portrait'
        };
        return true;
      }
      return false;
    },
    
    logout() {
      this.currentUser = null;
      this.currentShift = null;
    },
    
    selectShift(shift) {
      this.currentShift = shift;
    }
  });
  
  // 桌台管理
  Alpine.data('tableMap', () => ({
    tables: [],
    areas: ['大厅', '包间', '露台'],
    selectedArea: '大厅',
    
    init() {
      // 生成模拟桌台数据
      this.generateTables();
    },
    
    generateTables() {
      const statuses = ['idle', 'dining', 'reserved', 'locked'];
      this.tables = Array.from({ length: 24 }, (_, i) => ({
        id: i + 1,
        name: `${i + 1}号桌`,
        seats: Math.floor(Math.random() * 6) + 2,
        area: this.areas[Math.floor(Math.random() * this.areas.length)],
        status: statuses[Math.floor(Math.random() * statuses.length)],
        orderTime: new Date(Date.now() - Math.floor(Math.random() * 7200000)).toLocaleTimeString(),
        people: Math.floor(Math.random() * 6) + 1
      }));
    },
    
    getTablesByArea(area) {
      return this.tables.filter(table => table.area === area);
    }
  }));
  
  // 点菜系统
  Alpine.data('orderSystem', () => ({
    categories: ['热菜', '凉菜', '主食', '饮料', '酒水', '甜点'],
    selectedCategory: '热菜',
    dishes: [],
    currentOrder: {
      tableId: null,
      items: [],
      total: 0,
      note: ''
    },
    
    init() {
      this.generateDishes();
    },
    
    generateDishes() {
      const dishNames = [
        '宫保鸡丁', '水煮鱼', '麻婆豆腐', '鱼香肉丝', '糖醋排骨',
        '拍黄瓜', '皮蛋豆腐', '凉拌木耳', '龙井虾仁', '手撕包菜',
        '米饭', '蒸饺', '馒头', '炒饭', '炒面',
        '可乐', '雪碧', '果汁', '柠檬水', '矿泉水',
        '啤酒', '红酒', '白酒', '鸡尾酒', '威士忌',
        '提拉米苏', '芝士蛋糕', '冰淇淋', '水果拼盘', '布丁'
      ];
      
      this.dishes = dishNames.map((name, index) => ({
        id: index + 1,
        name,
        price: Math.floor(Math.random() * 80) + 20,
        category: this.categories[Math.floor(index / 5)],
        image: `https://source.unsplash.com/featured/?food,${name.replace(/\s/g, '')}`,
        soldOut: Math.random() > 0.9
      }));
    },
    
    getDishesByCategory(category) {
      return this.dishes.filter(dish => dish.category === category);
    },
    
    addToOrder(dish) {
      const existingItem = this.currentOrder.items.find(item => item.id === dish.id);
      
      if (existingItem) {
        existingItem.quantity += 1;
      } else {
        this.currentOrder.items.push({
          ...dish,
          quantity: 1,
          note: ''
        });
      }
      
      this.calculateTotal();
    },
    
    removeFromOrder(itemId) {
      this.currentOrder.items = this.currentOrder.items.filter(item => item.id !== itemId);
      this.calculateTotal();
    },
    
    updateQuantity(itemId, quantity) {
      const item = this.currentOrder.items.find(item => item.id === itemId);
      if (item) {
        item.quantity = quantity;
        this.calculateTotal();
      }
    },
    
    calculateTotal() {
      this.currentOrder.total = this.currentOrder.items.reduce(
        (sum, item) => sum + (item.price * item.quantity), 0
      );
    },
    
    placeOrder() {
      // 模拟下单逻辑
      console.log('订单已下单', this.currentOrder);
      return true;
    }
  }));
  
  // 结账系统
  Alpine.data('checkoutSystem', () => ({
    paymentMethods: ['现金', '微信', '支付宝', '刷卡', '会员'],
    selectedMethod: '现金',
    amount: 0,
    receivedAmount: 0,
    change: 0,
    
    calculateChange() {
      this.change = this.receivedAmount - this.amount;
      return this.change >= 0;
    },
    
    completePayment() {
      // 模拟完成支付
      return this.calculateChange();
    }
  }));

  // 预订单列表数据
  Alpine.data('preorderList', () => ({
    orders: [
      {
        id: 'PO2024050001',
        customer: '张先生',
        phone: '138****1234',
        time: '2024-05-10 18:30',
        people: 4,
        status: '待确认',
        items: [
          { name: '红烧排骨', quantity: 1, price: 68 },
          { name: '水煮鱼', quantity: 1, price: 88 },
          { name: '青椒土豆丝', quantity: 1, price: 28 }
        ],
        total: 184,
        note: '不要辣'
      },
      {
        id: 'PO2024050002',
        customer: '李女士',
        phone: '139****5678',
        time: '2024-05-10 19:00',
        people: 6,
        status: '已确认',
        items: [
          { name: '北京烤鸭', quantity: 1, price: 168 },
          { name: '宫保鸡丁', quantity: 1, price: 58 },
          { name: '蒜蓉西兰花', quantity: 1, price: 38 },
          { name: '番茄蛋汤', quantity: 1, price: 28 }
        ],
        total: 292,
        note: '窗边座位'
      },
      {
        id: 'PO2024050003',
        customer: '王总',
        phone: '136****9012',
        time: '2024-05-11 12:00',
        people: 10,
        status: '待确认',
        items: [
          { name: '海鲜大拼盘', quantity: 1, price: 288 },
          { name: '清蒸鲈鱼', quantity: 1, price: 138 },
          { name: '京酱肉丝', quantity: 2, price: 68 },
          { name: '干锅花菜', quantity: 1, price: 58 },
          { name: '小炒肉', quantity: 1, price: 58 }
        ],
        total: 678,
        note: '包间'
      }
    ],
    selectedOrder: null,
    showOrderDetail(order) {
      this.selectedOrder = order;
    },
    confirmOrder(order) {
      order.status = '已确认';
      this.selectedOrder = null;
    },
    cancelOrder(order) {
      const index = this.orders.findIndex(o => o.id === order.id);
      if (index > -1) {
        this.orders.splice(index, 1);
      }
      this.selectedOrder = null;
    }
  }));

  // 交接班数据
  Alpine.data('shiftHandover', () => ({
    currentUser: '王小明',
    shiftType: '早班',
    startTime: '2024-05-10 08:00',
    endTime: '2024-05-10 16:00',
    cashSummary: {
      initialCash: 1000,
      cashSales: 8562.50,
      cardSales: 12375.80,
      mobileSales: 15682.20,
      otherSales: 0,
      totalSales: 36620.50,
      expectedCash: 9562.50, // initialCash + cashSales
      actualCash: 9562.50,
      difference: 0
    },
    orders: {
      totalOrders: 68,
      completedOrders: 68,
      cancelledOrders: 0,
      averageAmount: 538.54
    },
    note: '',
    nextUser: '',
    nextShiftType: '晚班',
    isBalanced: true,
    noteMaxLength: 200,
    
    calculateDifference() {
      this.cashSummary.difference = this.cashSummary.actualCash - this.cashSummary.expectedCash;
      this.isBalanced = this.cashSummary.difference === 0;
    },
    
    completeHandover() {
      // 在实际应用中，这里会提交数据到服务器
      alert('交接班完成');
    },
    
    getNoteCharsLeft() {
      return this.noteMaxLength - this.note.length;
    }
  }));
}); 