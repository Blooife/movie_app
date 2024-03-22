import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/screens/auth/views/welcome_screen.dart';
import 'package:user_repository/user_repository.dart';
import '../blocs/bloc/update_user_bloc/update_user_bloc.dart';
import '../blocs/bloc/my_user_bloc/my_user_bloc.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/components/lists.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController phoneNumberController;
  late TextEditingController surnameController;
  late TextEditingController birthDateController;
  late TextEditingController countryController;
  late TextEditingController cityController;
  late TextEditingController aboutController;
  late ValueNotifier<String> genderController;
  late ValueNotifier<String> favCountryController;
  late ValueNotifier<String> favGenreController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    phoneNumberController = TextEditingController();
    surnameController = TextEditingController();
    birthDateController = TextEditingController();
    countryController = TextEditingController();
    cityController = TextEditingController();
    aboutController = TextEditingController();
    genderController = ValueNotifier<String>('Male');
    favCountryController = ValueNotifier<String>(Lists.countries[0]);
    favGenreController = ValueNotifier<String>(Lists.countries[0]);
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    phoneNumberController.dispose();
    surnameController.dispose();
    birthDateController.dispose();
    countryController.dispose();
    cityController.dispose();
    aboutController.dispose();
    genderController.dispose();
    favCountryController.dispose();
    favGenreController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;
      birthDateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('User Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            if (state.status == MyUserStatus.success) {
              final user = state.user!;
              nameController.text = user.name;
              ageController.text = user.age.toString();
              phoneNumberController.text = user.phoneNumber;
              surnameController.text = user.surname;
              birthDateController.text = DateFormat('yyyy-MM-dd').format(user.birthDate);
              countryController.text = user.country;
              cityController.text = user.city;
              aboutController.text = user.about;
              genderController.value = user.gender ? 'Male' : 'Female';
              favCountryController.value = user.favCountry;
              favGenreController.value = user.favGenre;
              

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16.0),
                    _buildTextField(lText: 'Name', contr: nameController, type: TextInputType.text),
                    const SizedBox(height: 16.0),
                    _buildTextField(lText: 'Surname', contr: surnameController, type: TextInputType.text),
                    const SizedBox(height: 16.0),
                    TextField(
                          controller: TextEditingController(text: user.email),
                          obscureText: false,   
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                        ),                          
                    ),
                    const SizedBox(height: 16.0),                    
                    GestureDetector(
                      onTap: () async {
                        await _selectDate(context, birthDateController);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: birthDateController,
                          obscureText: false,   
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Date of birth',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(CupertinoIcons.calendar),
                          ),                          
                        ),
                        ),
                      ),
                    
                    const SizedBox(height: 16.0),    
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, bottom: 5),
                          child: Text(
                          "Gender",                          
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        ),
                      Center(
                      child: ValueListenableBuilder<String>(
                      valueListenable: genderController,
                      builder: (context, value, child) {
                        return Container(                                                 
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio<String>(
                                value: 'Male',
                                groupValue: value,
                                onChanged: (newValue) {
                                  genderController.value = newValue!;
                                },
                              ),
                              const Text(
                                'Male',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 50),
                              Radio<String>(
                                value: 'Female',
                                groupValue: value,
                                onChanged: (newValue) {
                                  genderController.value = newValue!;
                                },
                              ),
                              const Text(
                                'Female',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        );
                      },
                    ),),
                  ],
                  ),                               
                  const SizedBox(height: 16.0),
                  _buildTextField(lText: 'Phone number', contr: phoneNumberController, type: TextInputType.phone),
                  const SizedBox(height: 16.0),
                  _buildTextField(lText: 'Country', contr: countryController, type: TextInputType.text),
                  const SizedBox(height: 16.0),
                  _buildTextField(lText: 'City', contr: cityController, type: TextInputType.text),
                    const SizedBox(height: 16.0),                    
                    TextField(
                          controller: aboutController,
                          obscureText: false,                      
                          maxLines: 3,
                          minLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            labelText: 'About me',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),                          
                        ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Preferences',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: favCountryController.value,
                      onChanged: (newValue) {                        
                        favCountryController.value = newValue!;                        
                      },
                      items: Lists.countries.map<DropdownMenuItem<String>>((String country) {
                        return DropdownMenuItem<String>(
                          value: country,
                          child: Text(country, style: const TextStyle(fontWeight: FontWeight.normal),),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: favGenreController.value,
                      onChanged: (newValue) {                        
                        favGenreController.value = newValue!;                        
                      },
                      items: Lists.genres.map<DropdownMenuItem<String>>((String genre) {
                        return DropdownMenuItem<String>(
                          value: genre,
                          child: Text(genre, style: const TextStyle(fontWeight: FontWeight.normal),),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Genre',
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0), 
                        ),
                      onPressed: () {
                        MyUser myUser = MyUser.empty;
                        myUser.userId = user.userId;
                        myUser.email = user.email;
                        myUser.name = nameController.text;
                        myUser.age = int.tryParse(ageController.text) ?? 0;
                        myUser.phoneNumber = phoneNumberController.text;
                        myUser.surname = surnameController.text;
                        myUser.birthDate = DateTime.tryParse(birthDateController.text) ?? DateTime.now();
                        myUser.country = countryController.text;
                        myUser.city = cityController.text;
                        myUser.about = aboutController.text;
                        myUser.gender = genderController.value == 'Male'; 
                        myUser.favorites = user.favorites;
                        myUser.favCountry = favCountryController.value;
                        myUser.favGenre = favGenreController.value;
                        context.read<UpdateUserBloc>().add(
                          UpdateUser(myUser),
                        );
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 16.0), 
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0), 
                        ),
                      onPressed: () {
                        context.read<UpdateUserBloc>().add(
                          DeleteUser(user.userId),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const WelcomeScreen(),
                          ),
                        );
                      },
                      child: const Text('Delete',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    ],
                    )
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String? lText,
    required TextEditingController contr,
    required TextInputType type,
  }) {
    return TextField(
      controller: contr,
      obscureText: false,   
      keyboardType: type,
      decoration: InputDecoration(
      labelText: lText,
      border: const OutlineInputBorder(),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      ),                          
    );
  }
}
