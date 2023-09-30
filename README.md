# Bitmex API로 따라만들어보기!!

## 구현 영상
![ezgif com-video-to-gif (1)](https://github.com/AnnaBaeTofuMom/BitmexClone/assets/61861862/df160b05-9da3-4a6e-8491-44e7b945a42e)

## 구현 항목 (필수항목 체크)
### Order Book
[X] orderBookL2:XBTUSD를 구독해서 정보를 받아옵니다.
[X] size가 qty로 사용됩니다.
[x] 매도/매수가 각각 20개씩 오름차순/내림차순으로 왼쪽과 오른쪽에 보여집니다.
[x] 합산된 볼륨을 각 행에 배경에 넣어주세요.

### Recent Trade
[x] trade:XBTUSD를 구독해서 정보를 받아옵니다.
[x] 최근 30개 내역을 최신순으로 보여줍니다.
[x] 매수는 초록, 매도는 빨강으로 나오도록 해주세요.
[ ] 새로 아이템이 추가되면 0.2초간 색이 채워지고 지워지도록 해주세요. (구현 항목인줄 인지 못하고 있었습니다!!! ㅠㅠ 죄송합니다)

## 어려웠던 점

### 데이터 정합성
Bitmex와 시간이 지나면 안맞는 부분이 종종 있는데 이유를 못찾았습니다.
제가 잘 못 구현한건지 뭔지 알 수 없는 부분이 있어서 시간을 버렸던 점이 아쉽습니다.

그리고 배열로 가지고 있는 데이터를 CRUD 하는 것이 순차적으로 잘 일어나야 하는 부분이 어려웠습니다.

### 시간 복잡도
제가 작성한 코드가 시간복잡도가 좋지 못한 것 같습니다.
N^2번 도는 경우는 없긴 하지만, N번을 굉장히 많이 돕니다...!!!ㅠㅠ
더 효율적인 방법이 있을 것 같은데 잘 모르겠습니다...

## 아쉬운 점

### 구조 설계 아쉬움
아직 좋은 구조를 설계하는 부분에 학습이 더 필요한 것 같습니다. 파일을 어디에 배치하는 것이 맞을지 스스로도 잘 모르고 있다는 생각이 들었습니다.

### 신규 스택을 적용하지 못했습니다.
처음에 SwiftUI와 Actor를 적용하려고 했었으나 공부하면서 진행하기 어려울 것 같아서 중도에 포기하고 기존 스택으로 진행하였습니다.

### Dependency Containter
주입을 해주는 부분을 빼먹었습니다. 간단한건데 아쉽습니다.

## 노력한 점
### Data Race
워낙 소켓이 빠르게 들어와서 Data Race가 심하게 발생하는 환경이었습니다. 소켓 매니저가 큐를 들고 있을까 하다가
그것도 한 큐에 너무 모일까봐 걱정이 되어서 각각의 뷰모델이 별도의 소켓을 가지고 있도록 처리하였습니다.

### 추석
추석에 코딩할 수 있을 줄 알았는데, 시골집에 다녀오고 나니 시간이 삭제되었습니다...
그래도 과제를 끝내려고 노력했습니다!

