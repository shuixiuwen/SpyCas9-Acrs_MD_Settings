draw delete all
draw color orange
set sel [atomselect top "chain B and name CA and (resid 762 to 821)"]
set resids [$sel get resid]

# 获取这些残基中的CA原子坐标并存储在列表中
set n_atoms [$sel num]
set coords [list]
for {set i 0} {$i < $n_atoms} {incr i} {
    lappend coords [lindex [$sel get {x y z}] $i]
}
#set res_list {762 763 764 765 766 767 768 769 770 771 772 773 774 775 776 777 778 779 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 800 801 802 803 804 805 806 807 808 809 810 811 812 813 814 815 816 817 818 819 820 821 858 857 856 855 840}
#foreach i $res_list {
#    set sel_i [atomselect top "chain B and name CA and resid $i"]
#    lappend coords [$sel_i get {x y z}]
#}

# 绘制圆柱连接
for {set i 0} {$i < [llength $coords]-1} {incr i} {
    set coord1 [lindex $coords $i]
    set x1 [lindex $coord1 0]
    set y1 [lindex $coord1 1]
    set z1 [lindex $coord1 2]

    set coord2 [lindex $coords [expr {$i+1}]]
    set x2 [lindex $coord2 0]
    set y2 [lindex $coord2 1]
    set z2 [lindex $coord2 2]

    # 检查坐标是否为空
    if {$x1 == "" || $y1 == "" || $z1 == "" || $x2 == "" || $y2 == "" || $z2 == ""} {
        continue
    }

    draw cylinder [list $x1 $y1 $z1] [list $x2 $y2 $z2] radius 0.5
}

set sel_1 [atomselect top "chain B and name CA and (resid 821 or resid 858)"]
draw cylinder [lindex [$sel_1 get {x y z}] 0] [lindex [$sel_1 get {x y z}] 1] radius 0.5
set sel_2 [atomselect top "chain B and name CA and (resid 858 or resid 857 or resid 856 or resid 855)"]
draw cylinder [lindex [$sel_2 get {x y z}] 0] [lindex [$sel_2 get {x y z}] 1] radius 0.5
draw cylinder [lindex [$sel_2 get {x y z}] 1] [lindex [$sel_2 get {x y z}] 2] radius 0.5
draw cylinder [lindex [$sel_2 get {x y z}] 2] [lindex [$sel_2 get {x y z}] 3] radius 0.5
set sel_3 [atomselect top "chain B and name CA and (resid 855 or resid 840)"]
draw cylinder [lindex [$sel_3 get {x y z}] 0] [lindex [$sel_3 get {x y z}] 1] radius 0.5
set sel_4 [atomselect top "chain B and name CA and (resid 10 or resid 11)"]
draw cylinder [lindex [$sel_4 get {x y z}] 0] [lindex [$sel_4 get {x y z}] 1] radius 0.5
set sel_5 [atomselect top "chain B and name CA and (resid 11 or resid 763)"]
draw cylinder [lindex [$sel_5 get {x y z}] 0] [lindex [$sel_5 get {x y z}] 1] radius 0.5
set sel_6 [atomselect top "chain B and name CA and (resid 983 or resid 984)"]
draw cylinder [lindex [$sel_6 get {x y z}] 0] [lindex [$sel_6 get {x y z}] 1] radius 0.5
set sel_7 [atomselect top "chain B and name CA and (resid 17 or resid 984)"]
draw cylinder [lindex [$sel_7 get {x y z}] 0] [lindex [$sel_7 get {x y z}] 1] radius 0.5
set sel_8 [atomselect top "chain B and name CA and (resid 17 or resid 10)"]
draw cylinder [lindex [$sel_8 get {x y z}] 0] [lindex [$sel_8 get {x y z}] 1] radius 0.5
set sel_9 [atomselect top "chain B and name CA and (resid 986 or resid 987)"]
draw cylinder [lindex [$sel_9 get {x y z}] 0] [lindex [$sel_9 get {x y z}] 1] radius 0.5
set sel_10 [atomselect top "chain B and name CA and (resid 9 or resid 987)"]
draw cylinder [lindex [$sel_10 get {x y z}] 0] [lindex [$sel_10 get {x y z}] 1] radius 0.5
set sel_11 [atomselect top "chain B and name CA and (resid 9 or resid 10)"]
draw cylinder [lindex [$sel_11 get {x y z}] 0] [lindex [$sel_11 get {x y z}] 1] radius 0.5