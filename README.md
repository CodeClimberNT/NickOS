# NixOS-nick

### First installation of NixOS 

Planning to use this repository to:
- Keep track of my learning history through this amazing OS
- Kind of a Journey Book/Diary
- Have a Backup (I know I'm able to break an unbreakable distro)
- Maybe more ? Idk for now

<hr>

# First Update 23/08
Already broke it :D
Started in a virtual machine, didn't remember to change boot folder, fortunately NixOS it's hard to break but my need to switch from systemd-boot to grub made me do really dumb stuff that culminate with the deletion of the boot partition for windows :DD <br>
I had no idea what I was thinking: when I saw the first partition with filesystem fat32 I though it would be impossible to be windows <br>
(**REMEMBER** i'm still a noob learning all this stuff)<br>
<br>
I'm doing this because is fun, although nix is not reccomended for new users I though: why not! I already new I would break it, but it's fun learning from my mistake, and i like how many teaching moment I already got through.<br>
<br>
So now I've already created the new boot partition for windows but still wasn't successful to log in (although i got to the first blue screen that show some potential fixes from the os itself), so I'm creating a recovery drive to hopefully repair without losing any data in my main drive (If comes down to it, i will switch to a live system and copy the file over, I'm not this dumb ;P).<br>
I will consider in the future a full linux system, but for now i'm trying with a double dual-boot (both desktop and laptop) to see what can I make of it.
<br>
To the next (hopefully good) Update

### Second Update 23/09
Got the time to try it again... it didn't ended, let's say, *perfect*: i wanted to make a dual boot system with both windows and nixos but got some problem switching from systemdboot to grub (why the installer don't make you choose from the start?!?)<br>
Initially everything worked great with a slight *tm* issue: the boot partition made by windows was too small so now i can't make any new build, and to make the matter worse with the last windows update it self destroyed: I'm unable to access windows operating system from the grub entry. I though it has something to do to with the update that maybe broken the grub mount point to windows, but i'm unable to access it also by the bios, making me realising now that i'm writing this that it could have been the limited boot partition size (oppsie).<br>
Now I made up my mind: full switch to nixos, at least for now. I wanted the windows safety net to avoid any problem with broken linux installation, but i got only more problems. I want to try the full linux experience and see where it will take me. The plus side is that, since I'm starting a new study in engineering nixos will be my best best for the os both for stability and reproducibility.<br>
I will keep you posted. 
P.S.<br>
All this happens weeks ago, but I had no time to update during the windows disaster.
