#include <jni.h>
#include <string>
#include <cwchar>
#include <locale>
#include <codecvt>
#include <iostream>
#include <fstream>
#include "text.h"
#include "await.h"
#include "wordcounter.h"

static jclass countWordsCallBackClass = nullptr;
static jmethodID countWordsCallbackMethod = nullptr;

void CacheCallback(JNIEnv *env) {
    // Get a reference to the Callback class
    jclass clazz = env->FindClass("com/romaktion/wordcounter/MainActivity");

    // Store a global reference, since the local one will be freed when returning from the function.
    countWordsCallBackClass = static_cast<jclass>(env->NewGlobalRef(clazz));

    // Get a reference to the static callback method
    jmethodID callback = env->GetStaticMethodID(countWordsCallBackClass,
            "countWordsCallback", "(II)V");

    // jmethodID doesn't need a NewGlobalRef call
    countWordsCallbackMethod = callback;
}

void ReleaseCallback(JNIEnv *env) {
    env->DeleteGlobalRef(countWordsCallBackClass);
    countWordsCallBackClass = NULL;

    // jmethodIDs are safe to keep without an explicit global reference, for this reason, we don't need to delete the reference either.
    countWordsCallbackMethod = NULL;
}

extern "C" jint JNI_OnLoad(JavaVM* vm, void* reserved)
{
    JNIEnv* env;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK)
    {
        return -1;
    }

    CacheCallback(env);

    return JNI_VERSION_1_6;
}

extern "C" void JNI_OnUnload(JavaVM* vm, void* reserved)
{
    JNIEnv* env;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK)
    {
        return;
    }

    ReleaseCallback(env);
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_romaktion_wordcounter_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {

    auto utf8 = std::make_unique<text>("Hello from wordcounter!", "UTF-8");
    auto res = utf8->byte_string().c_str();

    return env->NewStringUTF(res);
}

extern "C" JNIEXPORT jboolean JNICALL
Java_com_romaktion_wordcounter_MainActivity_countWords(
        JNIEnv* env,
        jobject/*this*/,
        jstring inFilePath,
        jstring outFilePath) {

    auto infilepath = env->GetStringUTFChars(inFilePath, 0);
    auto outilepath = env->GetStringUTFChars(outFilePath, 0);

    //run wordcounter
    const auto res = await([&infilepath]
                           {
                               auto queue = std::make_unique<wordcounter>(infilepath);
                               return queue->get();
                           });

    if (res.symbol_amount == 0)
    {
        std::cerr << "Symbol amount is null!\n";
        return static_cast<jboolean>(false);
    }

    //open file to write
    std::wofstream of(outilepath, std::ios::binary);
    if (!of.is_open())
    {
        std::cerr << "Can't open output file!\n";
        return static_cast<jboolean>(false);
    }
    of.imbue(std::locale(""));

    //write result
    for (const auto& r : res.words_amount)
        of << r.first << " - " << r.second << '\n';
    of.close();

    //counts
    auto wordcounter = 0u;
    for (const auto& wc : res.words_amount)
        wordcounter += wc.second;

    //cache callback
    env->CallStaticVoidMethod(countWordsCallBackClass, countWordsCallbackMethod,
            jint(res.symbol_amount), jint(wordcounter));

    return static_cast<jboolean>(res.words_amount.size() > 0);
}
