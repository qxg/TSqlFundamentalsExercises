rm template.sql
for i in {1..30}; do printf "%s Exercise %d\r\nSELECT \r\nFROM \r\n\r\n" "--" $i ; done > template.sql
for i in {2..11}; do cp template.sql ch0$i.sql; done
