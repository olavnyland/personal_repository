
# Import libraries


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from imblearn.over_sampling import SMOTE, ADASYN
from sklearn.metrics import accuracy_score, confusion_matrix, average_precision_score,precision_recall_curve
from sklearn.model_selection import train_test_split
from imblearn.under_sampling import RandomUnderSampler
from imblearn.over_sampling import SMOTE
from imblearn.combine import SMOTEENN
from collections import Counter
from imblearn.under_sampling import RandomUnderSampler
from sklearn.model_selection import GridSearchCV
from sklearn.linear_model import LogisticRegression
from sklearn.base import clone
from sklearn.preprocessing import RobustScaler
from tpot import TPOTClassifier
from tpot import TPOTRegressor

from sklearn.metrics import classification_report


df = pd.read_csv('creditcard.csv')
 
test_df = df.loc[:, ["Amount", "Class"]]

df.corr()

# Lets study our fraudulent transactions
minority = test_df[test_df.Class == 1]
minority["Amount"].plot.hist(bins=20)
minority[minority.Amount == 0].count()

minority_most_freq = minority["Amount"].value_counts(ascending=False).head(1)

# We observe 27 instances where fraudulent transactions equals zero, which doesn't make sense.
# I am assuming that the amount was not registered when creating this data. Therefore I chose 
# to set these transactions to equal the median of the fradulent transactions. 
replace_index = df[(df.Amount == 0) & (df.Class == 1)].index
df.loc[list(replace_index), "Amount"] = 1.0
df.loc[list(replace_index), "Amount"]

df[(df.Amount == 0) & (df.Class == 0)]["Amount"].plot.hist()
df.Amount.mean()

# Next let's look at our data that is not scaled. ....
df.Time.plot.hist(bins=100)
df.Amount.describe()

X = df.copy(deep=True)
y = X.pop('Class')

# SPLIT 60/20/20. 60% for training, 20% for validation, 20% for testing.

X_train, X_test, y_train, y_test = train_test_split(
    X, y, random_state=2017, test_size = .40, stratify=y)

# Let's check for imbalance in our training and test set
print('holdout shape test set %s' % Counter(y_test)) # Counter({0: 113726, 1: 197})
print('holdout shape training set %s' % Counter(y_train)) # Counter({0: 170589, 1: 295})

# In order to 
# Next, we split the test set into a holdout and validation set
X_value, X_test, y_value, y_test = train_test_split(
    X_test, y_test, random_state=42, test_size = .5, stratify=y_test)


# Check the imbalance of the majority and minority class on all datasets

print('holdout shape: hold-out set %s' % Counter(y_test)) # Counter({0: 56863, 1: 99})
print('holdout shape: validation set%s' % Counter(y_value)) # Counter({0: 56863, 1: 98})
print('holdout shape: training set %s' % Counter(y_train)) # Counter({0: 170589, 1: 295})

# Observe we have many observations of the minority class for training our model which is good


# We do not want to train our model on the imbalanced training set,  Counter({0: 170589, 1: 295})
# Therefore, we want to downsample the majority class using RandomUnderSampler()


# Downsample
#rus = RandomUnderSampler()
X_downsampled, y_downsampled = rus.fit_resample(X_train, y_train)


# Upsample minority class: SMOTE
X_smote, y_smote = SMOTE().fit_sample(X_train, y_train)

X_smote.corr()

# SMOTEENN
sme = SMOTEENN(random_state=42)
X_res, y_res = sme.fit_sample(X_train, y_train)


# NEXT, we declare which classifier we want to train our model with




#####  Logistic Regression model ######

param_grid = [{'C': list(np.arange(0.1,10,0.1))}]
clf = LogisticRegression()
model_smote = GridSearchCV(clf, param_grid, cv=5, return_train_score=True, n_jobs=-1)
model_smote.fit(X_smote, y_smote)
print(model_combined.best_params_)
print(model_combined.best_estimator_)


##### Random Forests Classifier ######


from sklearn.ensemble import RandomForestClassifier

param_grid_rfc = [{'max_depth': list(range(1,15))}]
clf_rfc = RandomForestClassifier()
grid_search_rfc = GridSearchCV(clf_rfc, param_grid_rfc, cv=5, return_train_score=True, n_jobs=-1)
grid_search_rfc.fit(X_smote, y_smote)
print("Best params: %s" %(grid_search_rfc.best_params_))
print(grid_search_rfc.best_estimator_)



# Test our model on the validation set. 
y_pred_rfc = grid_search_rfc.predict(X_value)
target_names = ['LEGIT', 'FRAUD']
print(classification_report(y_value, y_pred_rfc ,target_names=target_names))

rfc_prob = grid_search_rfc.predict_proba(X_value)[:,1]

average_precision_score(y_value, rfc_prob) # 0.85


precision, recall, thresholds = precision_recall_curve(y_value, rfc_prob)
auprc = auc(recall, precision) # 0.85
auprc

from matplotlib import pyplot
from sklearn.metrics import auc
pyplot.plot(recall, precision, marker='.', label='Random Forest Classifier: AUPRC = 0.85')
pyplot.xlabel("recall")
pyplot.ylabel("precision")
pyplot.title("AUPRC on Validation set")
pyplot.legend()
pyplot.show()

y_pred_rfc = grid_search_rfc.predict(X_value)
rfc_prob = grid_search_rfc.predict_proba(X_value)[:,1]
rfc_value = X_value.copy(deep=True)
rfc_value["pred_fraud"] = y_pred_rfc
rfc_value["pred_prob_fraud"] = rfc_prob
rfc_value["fraud (target)"] = y_value

rfc_value.to_excel(r"Random_Forest_Classifier_predictions.xls", header=True, index=None)



# From excel we found the optimal threshold to be 0.268605693340426

thold = 0.268605693340426
y_pred_test = grid_search_rfc.predict(X_test)
y_pred_prob = grid_search_rfc.predict_proba(X_test)[:,1]
y_pred_threshold = np.where(y_pred_prob > thold, 1, 0)

# MAX PROFIT
confusion_matrix(y_test, y_pred_threshold)
precision, recall, thresholds = precision_recall_curve(y_test, y_pred_threshold)
auprc = auc(recall, precision) # 0.716
auprc

target_names = ['LEGIT', 'FRAUD']
print(classification_report(y_test, y_pred_threshold ,target_names=target_names))

# BEST 
confusion_matrix(y_test, y_pred_test)
precision, recall, thresholds = precision_recall_curve(y_test, y_pred_prob)
auprc = auc(recall, precision) # 0.88
auprc



target_names = ['LEGIT', 'FRAUD']
print(classification_report(y_test, y_pred_test ,target_names=target_names))

# PLOT AUPRC 
pyplot.plot(recall, precision, marker='.', label='Random Forest Classifier: AUPRC = 0.0.88')
pyplot.xlabel("recall")
pyplot.ylabel("precision")
pyplot.title("AUPRC on TEST set")
pyplot.legend()
pyplot.show()


test_value = X_test.copy(deep=True)
test_value["pred_fraud"] = y_pred_threshold
test_value["pred_prob_fraud"] = y_pred_prob
test_value["fraud (target)"] = y_test

test_value.to_excel(r"HOLD OUT SET - PREDICTIONS (new).xls", header=True, index=False)






