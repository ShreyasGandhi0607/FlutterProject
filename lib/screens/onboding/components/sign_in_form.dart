import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:auth_project/entry_point.dart';
import 'package:auth_project/otp.dart';
import 'package:auth_project/utils/rive_utils.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

// Thank you so much for watching
// See you on next episode

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  void signIn(BuildContext context) {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(
      Duration(seconds: 1),
      () {
        if (_formKey.currentState!.validate()) {
          // If everything looks good it shows the success animation
          check.fire();
          Future.delayed(
            Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
              });
              // After closing it want to show the confetti animation
              // First let's add the animation
              // restart it
              confetti.fire();
              // Once all success we will navigate to the Next screen
              Future.delayed(
                Duration(seconds: 1),
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntryPoint(),
                      ));
                },
              );
            },
          );
        } else {
          // or error animation
          error.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
              });
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Phone Number",
                style: TextStyle(color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {
                    setState(() {
                      phoneController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter Phone Number",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          showCountryPicker(
                              context: context,
                              countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 500,
                              ),
                              onSelect: (value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              });
                        },
                        child: Text(
                          "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    suffixIcon: phoneController.text.length > 9
                        ? Container(
                            height: 30,
                            width: 30,
                            margin: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 22,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              // const Text(
              //   "P",
              //   style: TextStyle(color: Colors.black54),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8, bottom: 16),
              //   child: TextFormField(
              //     validator: (value) {
              //       if (value!.isEmpty) {
              //         return "";
              //       }
              //       return null;
              //     },
              //     onSaved: (password) {},
              //     obscureText: true,
              //     decoration: InputDecoration(
              //       prefixIcon: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 8),
              //         child: SvgPicture.asset("assets/icons/password.svg"),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyOtp()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF77D8E),
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    CupertinoIcons.arrow_right,
                    color: Color(0xFFFE0037),
                  ),
                  label: const Text("Send code"),
                ),
              ),
            ],
          ),
        ),
        // As you can see there is 3 trigger
        // Want to show the loading once user tab on the Sign in button
        // If all okey it should show success
        // otherwise error
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                  "assets/RiveAssets/check.riv",
                  onInit: (artboard) {
                    StateMachineController controller =
                        RiveUtils.getRiveController(artboard);
                    check = controller.findSMI("Check") as SMITrigger;
                    error = controller.findSMI("Error") as SMITrigger;
                    reset = controller.findSMI("Reset") as SMITrigger;
                  },
                ),
              )
            : const SizedBox(),

        // Looks good
        isShowConfetti
            ? CustomPositioned(
                child: Transform.scale(
                  scale: 7,
                  child: RiveAnimation.asset(
                    "assets/RiveAssets/confetti.riv",
                    onInit: (artboard) {
                      StateMachineController controller =
                          RiveUtils.getRiveController(artboard);

                      confetti =
                          controller.findSMI("Trigger explosion") as SMITrigger;
                    },
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      // Let's make it small
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
