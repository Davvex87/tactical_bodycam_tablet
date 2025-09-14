**THIS ADDON WAS NOT MADE BY ME, I JUST MODIFIED IT WITH QOL CHANGES**<br>
**YOU CAN FIND THE ORIGINAL [HERE](https://steamcommunity.com/sharedfiles/filedetails/?id=3517351423)**

# Tactical Bodycam Tablet - QoL Fixes

Adds a few quality of life features to the Tactical Bodycam Tablet addon, with DrgBase and VJBase nextbots support and extra client configurations to prevent clipping issues.

Testes on over 8 different DrgBase nextbot packs, 2 VJBase nextbot packs, Half-Life 2, EP2 and EP3 NPCs.

## Installing
Expand the "Code" dropdown button and click "Download ZIP". Once downloaded open your garrys mod addons/ folder (read how to [here](https://gist.github.com/BadgerCode/00600eab40556c6e8809590d263ea053)) and extract the ZIP into a folder inside the addons/ folder.<br>
DO NOT EXTRACT EVERYTHING INSIDE THE addons/ FOLDER, EVERYTHING MUST BE INSIDE ITS OWN FOLDER INSIDE THE addons/ FOLDER!!


## QNA (Help)

**Q: Which nextbots are supported?**<br>
A: Any nextbot from any base that contains a 3D rig. 2D nextbots are not supported.

**Q: The entity model is clipping through the camera/Everyting is dark!**<br>
A: You can adjust the "Camera Near Clip Plane" slider or tick the "Hide entity model on tablet view" option found in Q -> Options -> Antke -> BodyCam.

**Q: The camera is facing the wrong direction?!**<br>
A: This usually happens because the addon could not find a head attachment or bone to use as the nextbot's eyes and it may have chosen a chest attachment that is not facing the expected direction. There is no counter-measure to fix this, please file an issue [here](https://github.com/Davvex87/tactical_bodycam_tablet/issues) and provide a link to the nextbot addon pack and the nextbot name that you are having this issue with.

**Q: I'm having difficulties attaching to a nextbot/Can't attach at all to a nextbot!**<br>
A: Some nextbots are tricky to attach a camera to due to their complex models. Look down at the ground and spawn the nextbot, then equip the SWEP and try attaching a camera, try enabling noclip and moving around very slowly trying to attach, sometimes you have to find the sweet spot.

**Q: Why can I attach to props or doors?**<br>
A: Some addons mask objects, like props and doors, as entities due to their extra functionality.