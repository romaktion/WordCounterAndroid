SET REP_PATH=src/main/cpp/WordCounter

IF NOT EXIST %REP_PATH% goto GIT_CLONE

cd %REP_PATH%
git pull origin
exit

:GIT_CLONE

git clone https://github.com/romaktion/WordCounter.git %REP_PATH%
