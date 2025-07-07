# Squiggly: Spatial Design and CoreML for the Apple Vision Pro 
Introducing Squiggly! Squiggly is a visionOS application that explores drawing with physical utensils (crayons, pens, markers, and brushes) in immersive spaces. It is developed with RealityKit and SwiftUI in addition to the machine learning frameworks: BERT-SQuD, MNIST, and Apple's Vision Framework. This research prototype explores spatial user interfaces (UI) and graphics for 3D environments. 

<img width="552" alt="Screenshot 2025-07-02 at 5 18 54 PM" src="https://github.com/user-attachments/assets/2b77bf5b-b70b-423f-a629-e9aff5d0eeba" />

## Requirements 
  * XCode, Reality Commposer, CreateML
  * Hardware: Mac (ideally a computer with an M3/M4 chip) and an Apple Vision Pro
  * CoreML ([BERT-SQuAD](https://github.com/huggingface/transformers), [MNIST](http://yann.lecun.com/exdb/mnist/), [Vision Framework](https://developer.apple.com/documentation/vision/))
    
## Set Up

Install [XCode beta](https://developer.apple.com/support/install-beta/) (Version 26.0 beta 2) and visionOS beta. You will need to be running macOS Sonoma (version 14.0 or later).
<img width="885" alt="Screenshot 2025-07-06 at 5 02 26 PM" src="https://github.com/user-attachments/assets/35808960-6607-497e-b0d9-97f7596c51e5" />

Clone the repository
```bash
$ git clone https://github.com/debbieyuen/spatialui.git
```

Retrieve your **Access Token** for your app from [this page](https://api.slack.com/apps). In your terminal, add your token to your environment variables.

```bash
$ export VISION_TOKEN='xoxb-XXXXXXXXXXXX-xxxxxxxxxxxx-XXXXXXXXXXXXXXXXXXXXXXXX'
```

## Credits and References
This lab course will be presented at SIGGRAPH in Vancouver in August 2025. Special thank you to the teams at Apple and NVIDIA for helping us make this all possible.



