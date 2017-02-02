#setxkbmap -option grp:switch,grp:shifts_toggle,grp_led:scroll us,bg &
dropbox start
xautolock -time 15 -locker slock &
xrdb merge ~/.Xresources
xhost +local:
sxhkd &
#compton -c -e 0.5 -b 
exec bspwm
