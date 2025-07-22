# Squiggly 🎨

Introducing Squiggly! Squiggly is a visionOS 2 application that explores drawing with physical utensils (crayons, pens, markers, and brushes) in immersive spaces. It is developed with RealityKit and SwiftUI in addition to the machine learning frameworks: BERT-SQuD, MNIST, and Apple's Vision Framework. This research prototype explores spatial user interfaces (UI) and graphics for 3D environments. 

The physical objects, including crayon boxes (new box, broken box, condensed box), the individual crayon colors (yellow, blue, purple, orange, red, green, and pink), a stuffed Pokémon plushie, another 3D objects are trained on 3D models and collections of images before importing to CreateML. 
<img width="1052" alt="Screenshot 2025-07-19 at 6 34 54 PM" src="https://github.com/user-attachments/assets/52d40c3c-0ebc-4703-bffb-bc3c5f677c8c" />
<img width="1052" alt="Screenshot 2025-07-19 at 6 30 22 PM" src="https://github.com/user-attachments/assets/1b48b0d6-7711-488c-99fb-215768542dc5" />
<img width="1052" alt="IMG_0041" src="https://github.com/user-attachments/assets/8541f51a-f84d-46ab-9b7e-6572943e1562" />


## Requirements 
  * XCode, Reality Commposer, CreateML
  * Hardware: Mac (ideally a computer with an M3/M4 chip) and an Apple Vision Pro
  * CoreML ([BERT-SQuAD](https://github.com/huggingface/transformers), [MNIST](http://yann.lecun.com/exdb/mnist/))
  * [Apple Vision Framework](https://developer.apple.com/documentation/vision/)
    
## Set Up

This application can only be run on an Apple Vision Pro with visionOS 2.0 and higher. Created with an Apple Developer account (no enterprise APIs).

Install [XCode beta](https://developer.apple.com/support/install-beta/) (Version 26.0 beta 2) and visionOS beta. You will need to be running macOS Sonoma (version 14.0 or later).
<img width="1052" alt="Screenshot 2025-07-06 at 5 02 26 PM" src="https://github.com/user-attachments/assets/35808960-6607-497e-b0d9-97f7596c51e5" />

Install GitLFS
```
git install lfs
```

Fork the repository and then clone the forked repository
```bash
$ git clone https://github.com/debbieyuen/spatialui.git
```

Update submodule folders  to retrieve ML and Reality Composer files
```
git pull --recurse-submodules
git submodule update --init --recursive
```

Pull all LFS objects
```
git lfs pull
git submodule foreach 'git lfs pull'
```

Retrieve your **Access Token** for your app from [this page](https://huggingface.co/docs/hub/en/security-tokens). In your terminal, add your token to your environment variables.

```bash
$ export VISION_TOKEN='xoxb-XXXXXXXXXXXX-xxxxxxxxxxxx-XXXXXXXXXXXXXXXXXXXXXXXX'
```

## Credits and References
This lab course will be presented at SIGGRAPH in Vancouver in August 2025. Special thank you to the teams at Apple and NVIDIA for helping us make this all possible.



