# SNS Addiction Modeling

This project analyzes factors influencing student social media addiction using regression and clustering techniques. Key predictors include mental health, sleep duration, social media usage, and SNS-related conflicts.


## 🔍 Methods

- OLS Regression (with and without categorical variables)
- VIF for multicollinearity check
- Residual & ANOVA diagnostics
- Gaussian Mixture Model (GMM) clustering
- Group-wise regression comparison (Z-test on coefficients)

## 📊 Key Findings

- Mental health has the strongest negative effect on addiction.
- SNS-related conflicts and less sleep increase addiction risk.
- GMM identified two distinct addiction levels with different predictor sensitivities.

## 🚀 How to Run

```bash
git clone https://github.com/your-username/sns-addiction-modeling.git
cd sns-addiction-modeling
pip install -r requirements.txt
jupyter notebook sns_addiction_regression.ipynb
```


## 📁 Files

```bash
├── data
│   ├── Students Social Media Addiction.csv
│   └── Students Social Media Addiction.xlsx
├── docs
│   ├── Regression Tutorial.xlsx
│   └── SEM_Regression Tutorial.pdf
├── README.md
├── sns_addiction_regression.ipynb
├── sns_addiction_regression.pdf
├── sns_addiction_regression.tex
└── requirements.txt
```