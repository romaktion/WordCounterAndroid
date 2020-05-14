#include <jni.h>
#include <string>
#include "text.h"


extern "C" JNIEXPORT jstring JNICALL
Java_com_romaktion_wordcounter_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {





    auto utf8 = std::make_unique<text>("Hello from libiconv!", "UTF-8");
    auto res = utf8->byte_string().c_str();

    return env->NewStringUTF(res);
}
