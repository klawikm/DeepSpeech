# Running DeepSpeech on Raspberry Pi 2

On this page you will find description how to compile and run DeepSpeech native client on Raspberry Pi device. 

Contents
* The Build
* Model inference - speech recognition
* Conclusions
* Next steps

## The Build 

1. Building TensorFlow for Raspberry Pi

    Follow procedure described by **samjabrahams** and install basic dependencies, install pendrive as a swap for compiling, build *Bazel* and finally compile *Tensorflow*: <https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md>

    **NOTE 1**: it is time consuming process. On my Pi device Tensorflow compilation took **~24 hours**. 

    **NOTE 2**:

    I need to modify file /tensorflow/workspace.bzl. Replace lines:
    
    > "http://mirror.bazel.build/bitbucket.org/eigen/eigen/get/f3a22f35b044.tar.gz",
    >  "https://bitbucket.org/eigen/eigen/get/f3a22f35b044.tar.gz",

    with lines:

    > "http://mirror.bazel.build/bitbucket.org/eigen/eigen/get/d781c1de9834.tar.gz",
    > "https://bitbucket.org/eigen/eigen/get/d781c1de9834.tar.gz",

    Additionally replace lines:
    > sha256 = "ca7beac153d4059c02c8fc59816c82d54ea47fe58365e8aded4082ded0b820c4",
    > strip_prefix = "eigen-eigen-f3a22f35b044",

    with lines:
    > sha256 = "a34b208da6ec18fa8da963369e166e4a368612c14d956dd2f9d7072904675d9b",
    > strip_prefix = "eigen-eigen-d781c1de9834",

    **NOTE 3**: I use slightly different command to build Tensorflow (different target):

    > bazel build -c opt --copt="-mfpu=neon-vfpv4" --copt="-funsafe-math-optimizations" --copt="-ftree-vectorize" --copt="-fomit-frame-pointer" --local_resources 1024,1.0,1.0 --verbose_failures //tensorflow:libtensorflow_cc.so

2. Compile [libsox](https://sourceforge.net/projects/sox/). I used version *sox-14.4.2*.

3. Clone DeepSpeech repository from Git and follow instructions from <https://github.com/mozilla/DeepSpeech/blob/master/native_client/README.md> to build native client. 

*NOTE*: I had to change a few lines in BUILD file. I removed line:

> load("//tensorflow:tensorflow.bzl","if_x86")
 
Additionally I replaced this line:
> copts = [] + if_x86(["-mno-fma", "-mno-avx" -mno-avx2"]),

with:
> copts = [],

## Model inference - speech recognition

Go to folder where you have built *native client* and run command:

> ARGS="/home/pi/output_graph.pb /home/pi/test_11122.wav -t" make run

where */home/pi/output_graph.pb* is path to trained DeepSpeech model and */home/pi/test_11122.wav* is a path to audio file that you want to convert to text.

## Conclusions

Raspberry Pi 2 is able to run DeepSpeech models (default model complexity) but because of limited power model inference is very slow. Audio file that was 5 seconds long was processed for 15 seconds and audio file that was 15 seconds long was processed for 45 seconds. **It seems that *Pi* has not enough power to process long utterances but it should be able to process short voice commands (like "start", "stop", "slower", "faster") with acceptable delay.** 

## Next steps
* Run solution on Raspberry Pi 3 which should be ~30% faster
* Train simpler model (try to limit depth of neural network) - this should improve processing time on Pi device



