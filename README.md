# DrumApp - WORK IN PROGRESS

DrumApp is an iPad app for programming patterns inside a step sequencer.

DrumApp will feature a 12 x 16 grid on the right of the screen for note on/off features as well as track/step parameter changes. The controls will be on the left side of the screen. 

The DrumApp is a way to quickly creatre interesting loops. The flexibility of the DrumApp will not only allow users to program drum loops but also bass and melodic lines with individual track speeds, track play direction, track length and various parameters per track/step.

The DrumApp will be a great tool for producers to take with them while travelling and then return home to their studio and replace samples used in the app with sounds from hardware in the studio. 


## Features

The features of the DrumApp will include:
- Choose individual track length, speed and play direction including forward, reverse, random and ping pong.
- Edit individual step parameters for each track including note on/off, note length, velocity, pitch, octave, step retigger, trigger probability plus more yet to be decided.
- Individual track solos and mutes
- Sample allocation for each track plus basic effects (reverb, delay, eq)
- Midi output

Currently DrumApp is powered by AudioKit however this may change in the future to improve sequencer accuracy. I have noticed some latency issues already.


## Requirements

The following cocoaPods are required to run this project:
- pod 'AudioKit'
- pod 'SnapKit', '~> 4.0'


## Control Buttons Explained

### Home Button

When pressing the 'Home Button' users will be taken back to the initial screen. From the home screen, users can use the 12 x 16 matrix to turn notes on and off for each track and step.


### Shift Button 

The 'Shift Button' is what makes the DrumApp interesting and gives it an edge over other step sequencers and drum machines.

Once a user presses the shift button, they have access to 16 parameters such as velocity, pitch, octave, step retigger, trigger probability, track solos and mutes and many more yet to be determined.

The workflow is as such:
- From the home screen a user presses the shift button
- The user then choose a parameter they wish to change for any of the 12 tracks
- Some paramters such as track play direction or track mute/solo are toggle switches and the user will stay on the shift screen
- other paramaters such as velocity and pitch will take the user to a new page where they will be able to edit the selected parameter for the selected track at each step. Users can continue to turn notes on and off for the selected track and any given step


### Random Button 

If a user is on the home screen, they can press the 'Random Button' followed by any step button for any track and the track will fill with a random on/off value for each step. in this case, the step button acts as a probabilty setting so that users can increase the likelyhood of a step being turned on or off.

If a user has already selected a specific parameter for a track via the 'Shift Button', then pressing the 'Random Button' will randomise the values for all of the active steps.


### Preset Button

The 'Preset Button' is only active from the 'Home Screen' at this point. By pressing the 'Preset Button' and then a step button for a track, users will load a pre existing array of step on/off values for the given track.


### Play/Pause and Stop Buttons

These buttons have conventional use


## Current Progress

It must firstly be said that the sampler feature of the app are not yet implemented so DrumApp plays no sound. 

My focus so far has been on the sequencer play modes. I want DrumApp to be a very flexible tool and so the currect stage of the project is still determining a proof of concept. The current progress is promising although there are several issues, the main one being latency and poor accurancy of the sequencer.

Currently DrumApp will highlight the current sequencer step being played and users can change the play direction from forwards , reverse, random and ping pong and enter in step retrigger values from within the app. Users can also configure track length and track speed. At the moment track speed will simply play 1/1 BPM, 1/2 BPM, 1/3 BPM etc but this will later be configured to play more interesting time signatures.

It is also possible to code in the individual track lengths. The default setting is 16 beats but they can be any value between 1 and 16. I have not yet determined how users should change track length in the final product and therefore it is not implemented in the user interface.

Users can edit step parameters such as velocity, pitch, octave, step retigger, trigger probability, track solos and mutes however the app does not play sound in its current state.

The next features to be implemented will be:
- Tempo controls
- Implement the sampler features so that DrumApp plays sound
- Trigger probability
- Note offset
- Note length
- Finalise user interface
- Midi effects: users can jam and create different 'fill' type effects
- Song and Track Modes: users can pre load existing patterns for all tracks
- Midi output

Whilst the design and development of DrumApp is in its very early stages, the potential for such a step sequencer is large and all design aspects are likely to change as coding adventure continues.


## Author

Daniel Henshaw, danieljhenshaw@gmail.com


## License

WeatherApp is available under the [MIT license](https://opensource.org/licenses/MIT)
