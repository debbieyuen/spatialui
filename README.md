# Squiggly 🎨

Introducing Squiggly! Squiggly is a visionOS 2 application that explores drawing with physical utensils (crayons, pens, markers, and brushes) in immersive spaces. It is developed with RealityKit and SwiftUI in addition to the machine learning frameworks: BERT-SQuD, MNIST, and Apple's Vision Framework. This research prototype explores spatial user interfaces (UI) and graphics for 3D environments. 

The physical objects, including crayon boxes (new box, broken box, condensed box), the individual crayon colors (yellow, blue, purple, orange, red, green, and pink), a stuffed Pokémon plushie, another 3D objects are trained on 3D models and collections of images before importing to CreateML. 

<img width="1052" height="2048" alt="Simulator Screenshot - Apple Vision Pro - 2025-07-14 at 03 11 37" src="https://github.com/user-attachments/assets/a1efb353-4267-46b7-a333-c32cb9ab9b48" />

<img width="1052" height="766" alt="Screenshot 2025-07-14 at 3 12 36 AM" src="https://github.com/user-attachments/assets/06296013-2f2f-4e68-8421-9f8c785c24a1" />

## Requirements 
  * XCode, Reality Commposer, CreateML
  * Hardware: Mac (ideally a computer with an M3/M4 chip) and an Apple Vision Pro
  * CoreML ([BERT-SQuAD](https://github.com/huggingface/transformers), [MNIST](http://yann.lecun.com/exdb/mnist/))
  * [Apple Vision Framework](https://developer.apple.com/documentation/vision/)
    
## Set Up

This application can only be run on an Apple Vision Pro with visionOS 2.0 and higher. Created with an Apple Developer account (no enterprise APIs).

Install [XCode beta](https://developer.apple.com/support/install-beta/) (Version 26.0 beta 2) and visionOS beta. You will need to be running macOS Sonoma (version 14.0 or later).
<img width="1052" alt="Screenshot 2025-07-06 at 5 02 26 PM" src="https://github.com/user-attachments/assets/35808960-6607-497e-b0d9-97f7596c51e5" />

Clone the repository
```bash
$ git clone https://github.com/debbieyuen/spatialui.git
```

Retrieve your **Access Token** for your app from [this page](https://huggingface.co/docs/hub/en/security-tokens). In your terminal, add your token to your environment variables.

```bash
$ export VISION_TOKEN='xoxb-XXXXXXXXXXXX-xxxxxxxxxxxx-XXXXXXXXXXXXXXXXXXXXXXXX'
```

## Credits and References
This lab course will be presented at SIGGRAPH in Vancouver in August 2025. Special thank you to the teams at Apple and NVIDIA for helping us make this all possible.



