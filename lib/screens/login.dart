import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_dallant_wallet_app/screens/mainpage.dart';
import 'package:si_dallant_wallet_app/screens/signup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var idController = TextEditingController();
  var codeController = TextEditingController();

  static final storage = FlutterSecureStorage();

  String userInfo = ""; //user의 정보를 저장하기 위한 변수

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    //비동기로 flutter secure storage 정보를 불러오는 작업.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });

    _controller = VideoPlayerController.asset('assets/new_background_video.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
  }

  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    userInfo = (await storage.read(key: "login"))!;
    print(userInfo);

    //user의 정보가 있다면 바로 메인 페이지로 넘어가게 합니다.
    Get.offAll(
      MainPage(id: userInfo.split(" ")[1], pass: userInfo.split(" ")[3]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: VideoPlayer(_controller),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 200),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/dallant-logo2.png', width: 40),
                            const SizedBox(width: 10),
                            const Text(
                              'Dallant',
                              style: TextStyle(
                                fontFamily: 'Mtext',
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 120),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: idController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '아이디',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "아이디를 입력해주세요!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: codeController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '코드번호(Code-N)',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "코드번호를 입력해주세요!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            _formKey.currentState!.validate();
                            DocumentSnapshot userCode = await firestore
                                .collection('users')
                                .doc(idController.text.trim())
                                .get();
                            if (idController.text.trim() == userCode['id'] &&
                                codeController.text.trim() ==
                                    userCode['code']) {
                              print("로그인 성공");
                              // Get.to(const MainPage());

                              prefs.setString(
                                'userId',
                                idController.text.toString(),
                              );

                              // firestore.collection('users').doc(idController.text.trim()).update({
                              //   "dl": "0"
                              // });

                              await storage.write(
                                key: "login",
                                value:
                                    "id ${idController.text} password ${codeController.text}",
                              );

                              Get.to(
                                MainPage(
                                  id: idController.text,
                                  pass: codeController.text,
                                ),
                              );
                            } else {
                              print("로그인 실패");
                              Get.snackbar(
                                '계정정보가 잘못되었습니다.',
                                '아이디 나 코드번호를 다시 확인하세요!',
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,
                                forwardAnimationCurve: Curves.elasticInOut,
                                reverseAnimationCurve: Curves.easeOut,
                              );
                            }
                            // if(_formKey.currentState!.validate()){
                            //   print("로그인 성공");
                            //   Get.snackbar(
                            //     '로그인 되었습니다!',
                            //     '',
                            //     snackPosition: SnackPosition.BOTTOM,
                            //     forwardAnimationCurve: Curves.elasticInOut,
                            //     reverseAnimationCurve: Curves.easeOut,
                            //   );
                            //
                            //   Get.to(() => LoginPage(), arguments: mobileController.text.trim());
                            //
                            // }
                            // }
                          },
                          child: SizedBox(
                            height: 50,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    '로 그 인',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Get.to(SignupPage());
                          },
                          child: SizedBox(
                            height: 50,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    '회원가입',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (!await launchUrl(
                                  Uri.parse('http://www.kjbiz.co.kr/'),
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  throw '홈페이지를 열 수 없습니다. 잠시후 다시 시도하세요';
                                }
                              },
                              child: Text(
                                '회사홈페이지',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '|',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () async {
                                if (!await launchUrl(
                                  Uri.parse('https://poombuy.com/'),
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  throw '홈페이지를 열 수 없습니다. 잠시후 다시 시도하세요';
                                }
                              },
                              child: Text(
                                '쇼핑몰페이지',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
