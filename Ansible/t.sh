#!/bin/bash
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# ++++++++ Script To Create Storage Consumption Summary ++++++++ #
# ++++++++++++++++++++ HTML File Version++++++++++++++++++++++++ #
# ++++++++++++++++++++ DBTeam 03/02/2020 +++++++++++++++++++++++ #
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# +++++++++++++++++++++++ Variables ++++++++++++++++++++++++++++ #
Counter=$(df -h | sed 's/\%//g' | awk '+$5 >= 30 {print}'  | wc -l)
FS_LIST=/tmp/test.txt
DATE=$(date +%d/%m/%Y)
HTML_REPORT_PTH=/tmp/$(hostname)_Storage_Report.html
> $HTML_REPORT_PTH
echo "<html><head><style> body{ padding-top: 60px; padding-bottom: 40px; } .container{ width: 100%; margin: 0 auto; padding-top: 60px;padding-bottom: 20px } .fixed-header{ width: 100%; position: fixed; background: #333; padding: 1px 0; color: #fff;line-height: 20px; } .fixed-header{ top: 0; } .fixed-footer{ width: 100%; position: fixed; background: #333; padding: 1px; color: #fff; bottom: 0; } .container p{ line-height: 20px; }</style></head><body>" > $HTML_REPORT_PTH
echo "<div class='fixed-header'><h1 align=center><font size=6 color=white>"$(hostname)" Storage Consumption Summary</font></h1><h2 align=center><font size=6 color=white>"$DATE"</font></h2></div><div class='container'>" >> $HTML_REPORT_PTH
#++ This Line is to Get file-system that has n% free space and list it in file ordered by usage ++# 
df -h | sort -rn -k 5 | sed 's/\%//g' | awk '$5 >= 30 {print}'|  awk  "/[/]/" |  awk '{print $6 " || Total Space: "  $2 " || Used Space: " $3 " || Free Space: " $4 " || Usage: " $5 "%"}' > $FS_LIST
for ((i=1;i<$Counter;i++));
do
   D=$(cat $FS_LIST| awk 'NR=='$i'')
   echo "<details>\n<summary><font size=5 color=blue>""["$i"]" $D "</font></summary>"   >> $HTML_REPORT_PTH
   du -m  $D | sort -uk1rn | awk '$1 >= 512' | awk '{print "<p><font size="3">" ($1 / 1024) "G" "   " $2 "</font></p>"}' >> $HTML_REPORT_PTH   
   echo "</details>" >> $HTML_REPORT_PTH  
done
echo "</div> <div class='fixed-footer'> <p align=center>Developed by Database Team - Network International Egypt 2020</p></body></div></html>" >> $HTML_REPORT_PTH
#uuencode $HTML_REPORT_PTH $(hostname)_Storage_Report.html  


