# SNS Addiction Modeling

이 프로젝트는 학생들의 자기보고식 소셜미디어 **중독 점수(`Addicted_Score`)**와
행동·심리 변수(정신 건강, 수면 시간, SNS 사용 시간, SNS 관련 갈등 등) 사이의 통계적
연관을 회귀·진단·하위집단 분석으로 검토한다.

> ⚠️ **데이터에 관한 주의.** 사용 자료는 Kaggle에 공개된 **합성(synthetic) 데이터셋**
> ("Students' Social Media Addiction")이다. 종속 변수가 설명 변수들의 거의 결정론적
> 함수이며(704개 설명변수 조합이 모두 유일한 중독 점수에 대응), 상관·결정계수(R² ≈ 0.95)가
> 실제 행동과학 조사에서 나오기 어려운 수준이다. 따라서 본 보고서의 모든 수치는 **이 데이터셋의
> 생성 구조에 대한 기술(記述)**이며, 실제 학생 모집단에 대한 인과적·일반화 가능한 주장이 아니다.

## 🔍 Methods

- **전처리**: 완전 중복 행 제거(705 → 704)
- **OLS 회귀**: 수치형 모형 / 범주형 포함 모형, patsy `C()`로 더미 처리(더미 함정 회피)
- **추론**: 모든 계수에 **HC3 이분산-강건 표준오차** 사용
- **효과 크기 비교**: 원계수가 아니라 **표준화 계수(β)**
- **다중공선성**: VIF(절편 제외, 예측변수 기준)
- **모형 선택**: 조정 R² · AIC · BIC · **10-겹 교차검증** RMSE/R²
- **진단**: Q–Q·잔차·Scale-Location·Cook's D 그림 + **형식 검정**(Jarque–Bera,
  Breusch–Pagan, White, Ramsey RESET, Durbin–Watson)
- **강건성**: 영향관측치 제거 재적합, Huber 로버스트 회귀(RLM), **순서형 로지스틱 회귀**
- **하위집단/조절효과**:
  - 1: 전체 표본 **상호작용(그룹 × 예측변수) 모형** + Wald(Chow) 검정, BH(FDR) 보정
  - 2: **종속 변수를 제외한** 표준화 설명변수로 잠재프로파일(GMM), BIC·entropy 보고

## 📊 Key Findings (이 데이터셋에 한정, 상관 관계)

- **정신 건강 점수**는 수면·갈등 통제 후에도 중독 점수와 가장 강한 **음의 연관**(표준화 β ≈ −0.47).
  HC3, 로버스트 회귀, 순서형 로지스틱에서 모두 p < 0.001로 일관.
- **SNS 관련 갈등 경험**은 중독 점수와 강한 **양의 연관**(표준화 β ≈ +0.41).
- **수면 시간**은 **음의 연관**이나 효과 크기는 위 둘보다 작다(표준화 β ≈ −0.16).
- **일일 사용 시간·나이**는 단순 상관은 있으나 다른 변수 통제 시 **부분효과 비유의**.
  성별·학업 수준·플랫폼·관계상태의 추가 설명력은 미미.
- "중독 수준이 높을수록 요인 영향력이 감소한다"는 원 보고서의 결론은 **재현되지 않음** —
  종속 변수로 군집을 만들어 하위표본을 비교한 데서 온 통계적 인공물이었다.

## 🚀 How to Run

### 분석 노트북 실행

```bash
git clone https://github.com/sorrychoe/sns-addiction-modeling.git
cd sns-addiction-modeling
python -m venv .venv && source .venv/bin/activate   # Python 3.11+ 권장
pip install -r requirements.txt                     # jupyter 포함
jupyter notebook sns_addiction_regression.ipynb
```

- 데이터(`data/`)는 리포지토리에 포함되어 있어 별도 다운로드가 필요 없다.
- 난수 시드(`SEED`)가 고정되어 있어 위에서 아래로 순차 실행하면 결과가 재현된다.

### `.tex` / `.pdf` 리포트 재생성 (선택)

```bash
sh build.sh
```

추가 요구 사항:

- XeLaTeX를 포함한 TeX 배포판 + `kotex` 패키지 + 한글 폰트(예: Noto Sans CJK KR)
- `nbconvert` (위 `pip install`의 `jupyter`에 포함됨)

`build.sh`는 노트북을 재실행(`nbconvert --execute --inplace`)해 출력을 갱신한 뒤
LaTeX → PDF로 변환한다. 즉 추적 중인 `sns_addiction_regression.ipynb` /
`.tex` / `.pdf`를 덮어쓴다.

## 📁 Files

```text
├── data
│   ├── Students Social Media Addiction.csv
│   └── Students Social Media Addiction.xlsx
├── sns_addiction_regression.ipynb   # 분석 노트북 (본체)
├── sns_addiction_regression.tex     # 노트북에서 생성한 LaTeX 리포트
├── sns_addiction_regression.pdf     # 컴파일된 PDF 리포트
├── build.sh                         # 노트북 재실행 → .tex/.pdf 재생성 스크립트
├── requirements.txt
└── README.md
```
