import 'package:animated_login/animation_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtboard;
  // tmad controler lcol animation"haraka"
  // Artboard ykon andah controler wahad w yamhi lokhin
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String testEmail = "hasni@gmail.com";
  String testPassword = "1234567";
  final passwordFocusNode = FocusNode();
  // dart fal password khatrch tashakah ta3raf min tkon taktab fal pass dir animation wakhdokhra

  bool isLookingLeft = false;
  bool isLookingRight = false;
// zadt hado zoj bach fal if ta3 lengt<15 mayag3odch ri y3awad y3ayat l addLookLeftController li fih dakhal fa zadt  !isLookingLeft(ya3ni tkon fals tama ydirha ri khtra lawla w yraja3ha true)

  void removeAllControllers() {
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerLookLeft);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addSpecifcAnimationAction(
      RiveAnimationController<dynamic> neededAnimationAction) {
    removeAllControllers(); //min tabri tabadal animation tamhi kol controler w tzid li rak barih
    riveArtboard?.artboard.addController(neededAnimationAction);
  }

  void addIdleController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerIdle);
    debugPrint("idleee");
  }

  void addHandsUpController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsUp);
    debugPrint("hands up");
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsDown);
    debugPrint("hands down");
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerSuccess);
    debugPrint("Success");
  }

  void addFailController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerFail);
    debugPrint("Faillllll");
  }

  void addLookRightController() {
    removeAllControllers();
    isLookingRight = true;
    riveArtboard?.artboard.addController(controllerLookRight);
    debugPrint("Righttt");
  }

  void addLookLeftController() {
    removeAllControllers();
    isLookingLeft = true;
    riveArtboard?.artboard.addController(controllerLookLeft);
    debugPrint("Leftttt");
  }

  void checkForPasswordFocusNodeToChangeAnimationState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addSpecifcAnimationAction(controllerHandsUp);
      } else if (!passwordFocusNode.hasFocus) {
        addSpecifcAnimationAction(controllerHandsDown);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);

// rootbundle hiya fiha ga3 l assets
    //  .then i3mal haja , "data" tamsak animation
    rootBundle.load('assets/animated_login_screen.riv').then((data) {
      final file = RiveFile.import(
          data); //impord data li 3adna "animation compli ga3 l chakl(kol al itar)", w manah nado Artboard "animation" "mainArtboard li hiya chakl"
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });
    });

    // loadRiveFileWithItsStates();

    checkForPasswordFocusNodeToChangeAnimationState();
  }

  void validateEmailAndPassword() {
    // zadtalha future.delayed kharch di n3aytolha m3a "passwordFocusNode.unfocus();" bach yagla3 yadah,bsh lik tndar moraha lihada zadnalha wa9t
    Future.delayed(const Duration(milliseconds: 600), () {
      if (formKey.currentState!.validate()) {
        addSpecifcAnimationAction(controllerSuccess);
      } else {
        addSpecifcAnimationAction(controllerFail);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        passwordFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Animated Login"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: riveArtboard ==
                          null //ida kan mazal mayadi 9ima "lw9t li yach3l fih ykon null "dir SizedBox.shrink hiya "hiya asrar sizeebok " bilama ma tadi 9ima riveArtboard
                      ? const SizedBox.shrink()
                      : Rive(
                          // artboard for relod
                          artboard: riveArtboard!,
                        ),
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          validator: (value) =>
                              value != testEmail ? "Wrong email" : null,
                          onChanged:
                              (value) // lama user yaktab y change "yaktab"(kol mayaktab harf t3ayat lhadi l fun)
                              {
                            if (value.isNotEmpty &&
                                value.length < 17 &&
                                !isLookingLeft) {
                              addLookLeftController();
                            } else if (value.isNotEmpty &&
                                value.length >= 17 &&
                                !isLookingRight) {
                              addLookRightController();
                            }
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 25,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          focusNode: passwordFocusNode,
                          validator: (value) =>
                              value != testPassword ? "Wrong password" : null,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 18,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 8,
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.deepPurpleAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              "Login",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              passwordFocusNode.unfocus();
                              validateEmailAndPassword();
                            },
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
