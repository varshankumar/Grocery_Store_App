import 'package:flutter/material.dart';

void main() {
  Item("Apple", 1.5); //creates item which is put in list
  Item("Banana", 2.0); //creates item which is put in list
  Item("Orange", 1.0); //creates item which is put in list
  runApp(MyApp());
}

List cart = [];
double cost = 0.0;
Item selectedItem;
String productName;
String productPrice;
String payment;
double change;
bool purchaseSuccessful = false;
List items = []; //This list manages complexity

class Item {
  String name;
  double price;
  int stock;
  Item(String n, double p) {
    name = n;
    price = p;
    int x;
    Item itemInList;
    for (Item i in items) {
      if (i.name == this.name) {
        x = 1;
        itemInList = i;
        break;
      }
    }
    //when new item is created, it is added to list
    if (x != 1) {
      this.stock = 1;
      items.add(this); //adding item to list upon Item object construction
    } else {
      items[items.indexOf(itemInList)].stock += 1;
    }
  }
}

Color inStock(Item item) {
  int x;
  for (Item i in items) {
    if (i == item) {
      if (item.stock > 0) {
        x = 1;
        break;
      }
    }
  }
  if (x == 1) {
    return (Colors.lightGreenAccent[700]);
  } else {
    return (Colors.red[300]);
  }
}


//numeric checker idea from 
//https://www.codegrepper.com/code-examples/dart/how+to+check+if+input+is+
//double+in+dart
bool isDouble(String priceEntry) {
  if (priceEntry == null) {
    return false;
  }
  return double.tryParse(priceEntry) != null;
}

Color textFieldColor(input) {
  if (input == null) {
    return Colors.white;
  } else if (isDouble(input)) {
    return Colors.greenAccent[400];
  } else {
    return Colors.red;
  }
}

//error procedures idea from 
//https://stackoverflow.com/questions/53844052/how-to-make-an-alertdialog-
//in-flutter

priceError(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Invalid Price"),
    content: Text("Please provide a numeric value for price"),
    actions: [
      FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

nameError(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Invalid Name"),
    content: Text("Please product name"),
    actions: [
      FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

outOfStockError(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Product Out of Stock"),
    content: Text("Sorry. This Product is out of stock."),
    actions: [
      FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

payError(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Payment Too Low"),
    content: Text("Paid amount is less than total cost."),
    actions: [
      FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void purchaseSuccess(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Purchase Successful"),
    content: Text("The purchase is complete."),
    actions: [
      FlatButton(
        child: Text("OK"),
        onPressed: () {
          purchaseSuccessful = true;
          Navigator.pop(context);
        },
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void paymentError(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Payment Invalid"),
    content: Text("Please provide numeric value for payment."),
    actions: [
      FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void changeAlert(BuildContext context, double change) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Change"),
    content: Text("Please give customer \$$change as change."),
    actions: [
      FlatButton(
        child: Text("Customer has received change"),
        onPressed: () {
          Navigator.pop(context);

          change = null;
          Navigator.popAndPushNamed(context, 'purchaseSuccess');
        },
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void addProduct(BuildContext context, String name, String price) {
  if (isDouble(price)) {
    if (name != null) {
      bool productInStock = false;
      //looping through list to check if product that user wants to add
      //to stock is already in list
      for (Item i in items) {
        if (i.name == name) {
          items[items.indexOf(i)].stock += 1;
          productInStock = true;
          Navigator.popAndPushNamed(context, 'home');
          break;
        }
      }
      if (!productInStock) {
        
        Item(name, double.parse(price));
        productPrice = null;
        productName = null;
        productInStock = false;

        Navigator.popAndPushNamed(context, 'home');
      }
    } else {
      nameError(context);
    }
  } else {
    priceError(context);
  }
}

void purchase(context, paid) {
  if (isDouble(paid)) {
    paid = double.parse(paid);
    if (paid > cost) {
      changeAlert(context, paid - cost);
    } else if (paid < cost) {
      payError(context);
    } else {
      Navigator.popAndPushNamed(context, 'purchaseSuccess');
    }
  } else {
    paymentError(context);
  }
  change = null;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (context) => MyHomePage(),
        'checkout': (context) => Checkout(),
        'addToCart': (context) => AddToCart(),
        'addProduct': (context) => AddProduct(),
        'purchaseSuccess': (context) => PurchaseSuccess(),
      },
      title: 'CS Store',
      theme: ThemeData(
        primaryColor: Colors.black,
        canvasColor: Colors.grey[850],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'CS Store'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          
          backgroundColor: Colors.black,
          title: Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Add\nProduct",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "",
                    style: TextStyle(fontSize: 10),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, 'addProduct');
                    },
                    tooltip: 'AddProduct',
                    backgroundColor: Colors.red[500],
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              Column(children: <Text>[
                Text('Cost: \$$cost\n'),
                Text('Items: ' + cart.length.toString() + "\n"),
                Text('Select Item Below', style: TextStyle(fontSize: 25)),
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "\nCheckout",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "",
                    style: TextStyle(fontSize: 10),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "checkout");
                    },
                    tooltip: 'Checkout',
                    backgroundColor: Colors.blue[400],
                    child: Icon(Icons.shopping_cart),
                  ),
                ],
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            
            
          ),
          centerTitle: true,
          toolbarHeight: 150.0,
          
        ),
        body: Center(
            child: GridView.count(
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          crossAxisCount: 1,
          children: List.generate(items.length, (index) {
            return Container(
                child: FlatButton(
                    onPressed: () {
                      selectedItem = items[index];
                      Navigator.popAndPushNamed(context, 'addToCart');
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(75),
                        side: BorderSide(
                          width: 30,
                          color: Colors.grey[850],
                        )),
                    child: Column(
                      children: <Text>[
                        Text(
                          "\n\n\n",
                          style: TextStyle(fontSize: 31 ),
                        ),
                        Text(
                          items[index].name,
                          style: TextStyle(fontSize: 50),
                        ),
                        Text(
                          "Stock: " + items[index].stock.toString(),
                          style: TextStyle(fontSize: 50),
                        ),
                      ],
                    ),
                    color: inStock(items[index])));
          }),
        )));
  }
}

class Checkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Checkout"),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Center(
            child: Text(
              "",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(cart.length, (index) {
              return Container(
                  child: Text(
                      cart[index].name +
                          "\t\t\t\t\t\t\t\t\t\$" +
                          cart[index].price.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 40)));
            }),
          ),
          Text(
            "--------------------------------\n   Total Cost: \$$cost",
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          Center(
            child: Text(
              "",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Center(
            child: Text(
              "Customer Payment Amount:",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          Center(
            child: Text(
              "",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Center(
            child: SizedBox(
                width: 400,
                child: Theme(
                    data: ThemeData(
                      accentColor: Colors.white,
                      primaryColor: Colors.white,
                    ),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Customer Payment Amount',
                          labelStyle: TextStyle(color: Colors.white),
                          fillColor: Colors.white),
                      onChanged: (String value) {
                        payment = value;
                      },
                    ))),
          ),
          Center(
            child: Text(
              "",
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(
            height: 70,
            width: 270,
            child: FlatButton(
              onPressed: () {
                purchase(context, payment);
                //while (!purchaseSuccessful) {}
                //Navigator.popAndPushNamed(context, 'home');
                payment = null;
                purchaseSuccessful = false;
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    width: 100,
                    color: Colors.lightGreenAccent[400],
                  )),
              child: Text(
                'Purchase',
                style: TextStyle(fontSize: 40),
              ),
              color: Colors.lightGreenAccent[400],
              autofocus: true,
            ),
          ),
          Center(
            child: Text(
              "",
              style: TextStyle(fontSize: 10),
            ),
          ),
          SizedBox(
            height: 70,
            width: 270,
            child: FlatButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, 'home');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    width: 100,
                    color: Colors.lightGreenAccent[400],
                  )),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 40),
              ),
              color: Colors.red[400],
              autofocus: true,
            ),
          ),
        ]));
  }
}

class AddToCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add " + selectedItem.name + " to Cart",
            //style: TextStyle(
            //color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  selectedItem.name,
                  style: TextStyle(fontSize: 100, color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "\$" + selectedItem.price.toString(),
                  style: TextStyle(fontSize: 100, color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 100),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 70,
                  width: 270,
                  child: FlatButton(
                    onPressed: () {
                      if (selectedItem.stock > 0) {
                        cost += selectedItem.price;
                        cart.add(selectedItem);
                        items[items.indexOf(selectedItem)].stock -= 1;
                        selectedItem = null;
                        Navigator.popAndPushNamed(context, 'home');
                      } else {
                        outOfStockError(context);
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          width: 100,
                          color: Colors.lightGreenAccent[400],
                        )),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 40),
                    ),
                    color: Colors.lightGreenAccent[400],
                    autofocus: true,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 70,
                  width: 270,
                  child: FlatButton(
                    onPressed: () {
                      selectedItem = null;
                      Navigator.popAndPushNamed(context, 'home');
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          width: 100,
                          color: Colors.lightGreenAccent[400],
                        )),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 40),
                    ),
                    color: Colors.red[400],
                    autofocus: true,
                  ),
                ),
              )
            ]));
  }
}

class AddProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Product",
            //style: TextStyle(
            //color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  "Product Name:",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Center(
                child: SizedBox(
                    width: 400,
                    child: Theme(
                        data: ThemeData(
                          accentColor: Colors.white,
                          primaryColor: Colors.white,
                        ),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Product Name',
                              labelStyle: TextStyle(color: Colors.white),
                              fillColor: Colors.white),
                          onChanged: (String value) {
                            productName = value;
                          },
                        ))),
              ),
              Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Center(
                child: Text(
                  "Product Price:",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Center(
                child: SizedBox(
                    width: 400,
                    child: Theme(
                        data: ThemeData(
                            accentColor: Colors.white,
                            primaryColor: Colors.white),
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Product Price',
                              labelStyle: TextStyle(color: Colors.white)
                              //focusColor: Colors.white,
                              //fillColor: Colors.white
                              ),
                          onChanged: (String value) {
                            productPrice = value;
                          },
                        ))),
              ),
              Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 70,
                  width: 270,
                  child: FlatButton(
                    onPressed: () {
                      addProduct(context, productName, productPrice);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          width: 100,
                          color: Colors.lightGreenAccent[400],
                        )),
                    child: Text(
                      'Add Product',
                      style: TextStyle(fontSize: 40),
                    ),
                    color: Colors.lightGreenAccent[400],
                    autofocus: true,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 70,
                  width: 270,
                  child: FlatButton(
                    onPressed: () {
                      selectedItem = null;
                      Navigator.popAndPushNamed(context, 'home');
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          width: 100,
                          color: Colors.lightGreenAccent[400],
                        )),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 40),
                    ),
                    color: Colors.red[400],
                    autofocus: true,
                  ),
                ),
              )
            ]));
  }
}

class PurchaseSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Purchase Successful"),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Center(
            child: Text(
              "",
              style: TextStyle(fontSize: 80),
            ),
          ),
          SizedBox(
              width: 500,
              child: Center(
                  child: OutlineButton(
                      onPressed: () {},
                      shape: CircleBorder(),
                      borderSide: BorderSide(
                        color: Colors.lightGreenAccent[400],
                        width: 10,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 300,
                        color: Colors.lightGreenAccent[400],
                      )))),
          Center(
            child: Text(
              "",
              style: TextStyle(fontSize: 90),
            ),
          ),
          SizedBox(
            height: 70,
            width: 270,
            child: FlatButton(
              onPressed: () {
                cart = [];
                cost = 0;
                Navigator.popAndPushNamed(context, 'home');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    width: 100,
                    color: Colors.lightGreenAccent[400],
                  )),
              child: Text(
                'New Order',
                style: TextStyle(fontSize: 40),
              ),
              color: Colors.lightGreenAccent[400],
              autofocus: true,
            ),
          ),
        ]));
  }
}
