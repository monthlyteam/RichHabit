import 'package:flutter/material.dart';

const kPurpleColor = Color(0xff585A79);
const kDarkPurpleColor = Color(0xff303246);
const kIvoryColor = Color(0xffFFE4D3);
const kWhiteIvoryColor = Color(0xffFFF1EA);
const kSelectedColor = Color(0xffDE711E);

const kTitleFontSize = 25.0;
const kSubTitleFontSize = 20.0;
const kNormalFontSize = 12.0;

const kPadding = 20.0;
Size size;
bool kKeyboardIsOpened;

const kWarningList = [
  "담배는 돈뿐만 아니라 건강에도 최악!", //흡연
  "한 잔, 한 잔이 쌓인 돈이 \n엄청난 차이를 만듭니다!", //커피(음료)
  "건강에도 NO! 돈도 NO!", //음주
  "제발 음식은 사서 드세요", //외식
  "택시보단 걸으며 산책을 해보는 건 어떤가요?", //택시
  "우리 조금만 더 유혹을 참아봐요!", //군것질
  "노는 것도 좋지만 목표는 지키자구요!", //피씨방
  "게임은 좋은 취미지만\n과도한 과금은 좋지 않아요!", //게임
];
//사용자가 커스텀한 습관일 경우 이중 하나 랜덤으로 나오게
const kCustomWaringList = [
  "돈이 없으면 방랑자, \n돈이 있으면 관광객이라 불린다",
  "내가 잃어버린 복리의 힘이 저만큼이나!?",
  "목표 초과!",
  "앞으로는 목표치를 지키기 위해\n함께 노력해봐요!",
  "내가 정한 목표 열심히 지켜봐요!",
  "한 번일 뿐이지만 복리의 가치는...",
];

const defualtHabitList = [
  ["흡연", 'assets/images/icon/smoking.svg'],
  ["커피(음료)", 'assets/images/icon/coffee.svg'],
  ["음주", 'assets/images/icon/beer.svg'],
  ["외식", 'assets/images/icon/eatingout.svg'],
  ["택시", 'assets/images/icon/taxi.svg'],
  ["군것질", 'assets/images/icon/snacks.svg'],
  ["피씨방", 'assets/images/icon/pcroom.svg'],
  ["게임", 'assets/images/icon/game.svg'],
  ["추가", 'assets/images/icon/custom_coin.svg']
];

const triggerList = [
  ["양치질", "assets/images/icon/teeth.svg"],
  ["식사", "assets/images/icon/meal.svg"],
  ["샤워", "assets/images/icon/shower.svg"],
];
