import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBM9D9_CVuIRNjIBqeKhOoRjeS0LmINyCA',
      appId: '1:1030374510851:android:29d2fcd41ccc164b71d936',
      messagingSenderId: '1030374510851',
      projectId: 'blooddonation-4c1b7',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(), // Include HomePage widget here
    BloodSearchPage(),
    BloodDonationForm(),
    DonationOpportunities(),
    LoginScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donation App'),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search Blood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Donate Blood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Donate Money',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}


class BloodDonationForm extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _retypePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donation Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'About Blood Donors: Register\n'
                'Please fill the following information to register as voluntary blood donor and become part of Ak\'s Vision. '
                'Kindly update your date of donation once done, so that your name will be hidden automatically till next 3 Months. '
                'Also please update your profile/information if in case you relocate in future.',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Registration',
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Fill Me Up',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _bloodGroupController,
                decoration: InputDecoration(labelText: 'Blood Group'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _mobileNumberController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Country'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'State'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _districtController,
                decoration: InputDecoration(labelText: 'District'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email Id'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _userIdController,
                decoration: InputDecoration(labelText: 'User Id'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _retypePasswordController,
                decoration: InputDecoration(labelText: 'ReType -Password'),
                obscureText: true,
              ),
              SizedBox(height: 10),
              DonationCheckbox(
                label: 'Confirm your availability to donate blood:',
              ),
              SizedBox(height: 10),
              DonationCheckbox(
                label:
                    'I authorize this website to display my name and telephone number, so that the needy could contact me, as and when there is an emergency.',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Submit the form
                  try {
                    UserCredential userCredential =
                        await _auth.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    // Add user details to Firestore
                    await _firestore.collection('users').doc(userCredential.user!.uid).set({
                      'firstName': _firstNameController.text,
                      'bloodGroup': _bloodGroupController.text,
                      'mobileNumber': _mobileNumberController.text,
                      'country': _countryController.text,
                      'state': _stateController.text,
                      'district': _districtController.text,
                      'city': _cityController.text,
                      'email': _emailController.text,
                      'userId': _userIdController.text,
                      // Add other fields as needed
                    });

                    // Navigate to success screen
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessScreen()));

                  } catch (e) {
                    print('Error: $e');
                    // Show error message to user
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DonationCheckbox extends StatefulWidget {
  final String label;

  DonationCheckbox({required this.label});

  @override
  _DonationCheckboxState createState() => _DonationCheckboxState();
}

class _DonationCheckboxState extends State<DonationCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(widget.label),
        ),
        Checkbox(
          value: _isChecked,
          onChanged: (bool? value) {
            setState(() {
              _isChecked = value ?? false;
            });
          },
        ),
      ],
    );
  }
}


class BloodSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Blood'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Blood Group'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Country'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'State'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'District'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'City'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform search
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}

class DonationOpportunities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Opportunities'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          DonationCard(
            name: 'John Doe',
            age: 35,
            location: 'XYZ City',
            description:
                '✓ John Doe is a father of two children who lost his job due to the pandemic. He is struggling to provide food for his family. Any help would be greatly appreciated.',
          ),
          SizedBox(height: 20),
          DonationCard(
            name: 'Jane Smith',
            age: 40,
            location: 'ABC Town',
            description:
                '✓ Jane Smith is a single mother who recently underwent surgery and is unable to work. She needs assistance with medical bills and daily expenses.',
          ),
        ],
      ),
    );
  }
}

class DonationCard extends StatelessWidget {
  final String name;
  final int age;
  final String location;
  final String description;

  const DonationCard({
    required this.name,
    required this.age,
    required this.location,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Age: $age'),
            Text('Location: $location'),
            SizedBox(height: 12.0),
            Text(description),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonationForm()),
                );
              },
              child: Text('Donate'),
            ),
          ],
        ),
      ),
    );
  }
}

class DonationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Donate:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Amount to Donate'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Process donation
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BloodDonationForm()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Add your login logic here
                // For now, just show a message
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Login Successful"),
                    content: Text("Welcome! Thanks for logging in."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donation System'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/blood.jpg',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Save Lives, Donate Blood',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why Donate Blood?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Donating blood saves lives. The blood you donate is used to treat patients in need of blood transfusions due to accidents, surgeries, or medical conditions. By donating blood, you can make a significant impact on someone\'s life.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'How You Can Help',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Aside from donating blood, you can also help by spreading awareness about the importance of blood donation. Encourage your friends, family, and community members to donate blood regularly. Additionally, consider volunteering at blood drives or organizing donation events in your area.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BloodDonationForm()),
                  );
                },
                child: Text('Donate Now'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoreInformationPage()),
                  );
                },
                child: Text('Learn More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoreInformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement your more information page UI here
    return Scaffold(
      appBar: AppBar(
        title: Text('More Information'),
      ),
      body: Center(
        child: Text('More Information'),
      ),
    );
  }
}
