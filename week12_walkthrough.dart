
/// The basic that every coffee item must have.
/// The prepare() method describes how the coffee is prepared.
abstract class CoffeeItem {
  String prepare();
}

/// Parent class for different types of coffee.
/// It stores coffee details and handles displaying and purchasing coffee.
abstract class Coffee extends CoffeeItem {
  String name;
  double price;
  String size;

  // variable that stores the available stock.
  int _stock;

  /// knowing the coffee name, price, size, and starting stock.
  Coffee(this.name, this.price, this.size, this._stock);

  /// Allows other classes to read the stock without changing it directly.
  int get stock => _stock;

  /// Displays the coffee information and its preparation method.
  void displayInfo() {
    print('Coffee Name: $name');
    print('Price: PHP ${price.toStringAsFixed(2)}');
    print('Size: $size');
    print('Available Stock: $_stock');
    print('Preparation: ${prepare()}');
  }

  /// Validates the quantity, updates the stock, and prints the purchase details.
  void buyCoffee(int quantity) {
    if (quantity <= 0) {
      print('Invalid quantity. Please enter a positive number.');
    } else if (quantity > _stock) {
      print('Sorry, not enough stock for $name.');
    } else {
      _stock -= quantity;
      double total = price * quantity;

      print('Successfully purchased $quantity $name.');
      print('Total Price: PHP ${total.toStringAsFixed(2)}');
      print('Remaining Stock: $_stock');
    }
  }

  /// Processes a purchase to simulate order processing time.
  /// It returns a result message after checking the quantity and stock.
  Future<String> buyCoffeeAsync(int quantity) async {
    if (quantity <= 0) {
      return 'Invalid quantity. Please enter a positive number.';
    }

    if (quantity > _stock) {
      return 'Sorry, not enough stock for $name.';
    }

    // Simulate by waiting while the order is being processed.
    await Future.delayed(Duration(seconds: 2));

    // Updates the stock only after the waiting period.
    _stock -= quantity;
    double total = price * quantity;

    return 'Successfully purchased $quantity $name. '
        'Total: PHP ${total.toStringAsFixed(2)}. '
        'Remaining stock: $_stock.';
  }
}

/// Presents hot coffee and provides its specific preparation.
class HotCoffee extends Coffee {
  /// Passes the coffee details to the parent Coffee constructor.
  HotCoffee(String name, double price, String size, int stock)
      : super(name, price, size, stock);

  /// Overrides the parent method with the hot coffee preparation process.
  @override
  String prepare() {
    return 'Brewing with hot water.';
  }
}

/// Presents iced coffee and provides its specific preparation.
class IcedCoffee extends Coffee {
  /// Passes the coffee details to the parent Coffee constructor.
  IcedCoffee(String name, double price, String size, int stock)
      : super(name, price, size, stock);

  /// It is the parent method with the iced coffee preparation process.
  @override
  String prepare() {
    return 'Mixing with ice and cold milk.';
  }
}

/// Provides a functionality for printing a customer receipt.
mixin ReceiptMixin {
  /// Prints the customer name, total payment, and thank-you message.
  void printReceipt(String customerName, double total) {
    print('\n---------- COFFEE SHOP RECEIPT ----------');
    print('Customer: $customerName');
    print('Total: PHP ${total.toStringAsFixed(2)}');
    print('Thank you for ordering!');
    print('-----------------------------------------');
  }
}

/// Uses ReceiptMixin to gain access to the receipt-printing method.
class ReceiptPrinter with ReceiptMixin {}

/// Entry point of the program.
/// it allows main() to wait for the asynchronous purchase operation.
Future<void> main() async {
  // Creates a list containing two coffee products.
  List<Coffee> coffeeMenu = [
    IcedCoffee('Iced Latte', 129.00, 'Medium', 10),
    HotCoffee('Caramel Macchiato', 159.00, 'Large', 8),
  ];

  // Prints the menu heading.
  print('-----------------------------------------');
  print('       COFFEE SHOP MENU');
  print('-----------------------------------------');

  // Loops through the menu and displays each coffee's information.
  for (Coffee coffee in coffeeMenu) {
    print('');
    coffee.displayInfo();
    print('-----------------------------------------');
  }

  // Starts the purchase demonstration.
  print('\n------ ASYNC CUSTOMER PURCHASE ------');

  // Selects the first coffee in the menu.
  Coffee coffee1 = coffeeMenu[0];

  print('Submitting order for 2 ${coffee1.name}...');
  print('Please wait for the order confirmation.');

  // Prints a message after one second and the purchase is processing.
  Future.delayed(Duration(seconds: 1), () {
    print('The program is still running while the order is processed.');
  });

  // Waits for the purchase result before continuing.
  String result = await coffee1.buyCoffeeAsync(2);

  print('\n$result');

  // Displays the updated stock of every coffee product.
  print('\n------ UPDATED STOCK ------');
  for (Coffee coffee in coffeeMenu) {
    print('${coffee.name} remaining stock: ${coffee.stock}');
  }

  // Tests the validation by attempting to buy more coffee than available.
  print('\n------ STOCK VALIDATION TEST ------');
  coffeeMenu[1].buyCoffee(20);

  // Creates a receipt printer and prints the sample receipt.
  ReceiptPrinter printer = ReceiptPrinter();
  printer.printReceipt('Student', 129.00 * 2);
}
