#setxkbmap -option grp:switch,grp:shifts_toggle,grp_led:scroll us,bg &
dropbox start

#cvt 1600 900 59.84
xrandr --newmode "1600x900"  118.00  1600 1696 1856 2112  900 903 908 934 -hsync +vsync
xrandr --addmode eDP-1 "1600x900"
xrandr --dpi 192

xsetroot -xcf /usr/share/icons/default/cursors/left_ptr 48
xsetroot -solid $(getcolor color0)
xautolock -time 15 -locker slock &
xrdb merge ~/.Xresources
xhost +local:

sxhkd &
exec bspwm
