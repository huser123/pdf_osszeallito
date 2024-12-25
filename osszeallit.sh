#!/bin/sh

clear



echo ""
echo "A script elindult!"
echo ""

echo ""
echo "A munkakönyvtár tisztítása és / vagy létrehozása!"

rm -Rfv png jpg
mkdir png

echo ""

echo "A képek kibontása a PDF-ből (eltarthat egy ideig)"

echo ""

szam=0

for i in *.pdf
do
((szam++))
echo $i " számú pdf kibontása"
pdfimages -all $i ./png/$i
echo ""

done

cd png

echo "A jpg képek törlése"
echo ""


rm -Rfv *.jpg
echo ""
echo ""

echo "A png képek kiválogatása felbontás szerint"

for i in *.png
do

meret=$(exiftool -q -r $i -p '$ImageHeight')
echo $meret

if (($meret< 1500))
then
echo "A "$meret" kisebb, mint 1500 ezert toroljuk!"
rm -Rfv $i
echo ""
fi

done

echo ""
echo ""
echo "A kisfelbontású képek törölve!"
echo "Elkezdjük az azonos képek törlését"
echo ""
echo ""

## md5 összehasonlító 2021.02.12

i=0 # index nullázás
n=0 # index nullázás
m=0 # index nullázás

# fájlista tulajdonságok beolvasása
while read line
do
    fajlok[ $i ]="${line:33}"        # fájlok neveinek beolvasása (a 33. karaktertől)
    fajlokmd[ $i ]="${line:0:32}"    # fájlok md5 összegének beolvasása (az első 32. karakter)
    (( i++ ))                        # index növelése
done < <(md5sum *)                   # az md5 összegek generálása

    #echo ${fajlokmd[*]}             # az eddigi működést ellenőrző sor

    elemek=${#fajlokmd[@]}           # az elemszám változóba mentése
    ((elemek--))                     # a változó értékének egyel csökkentése

for n in $(seq 0 $elemek)           # első elemtől az utolsóig
do

    for m in $(seq $elemek -1 $n)   # utolsótól az első elemig
    do
        if [[ $n != $m ]]           # csak akkor, ha a két index nem egyelő
        then
            if [[ ${fajlokmd[$n]} = ${fajlokmd[$m]} ]] # megvizsgálni a két elem relációját
            then
                echo -e "Megegyezik" "\e[1;31m" ${fajlok[$n]} "\e[0m" és "\e[1;31m" ${fajlok[$m]} "\e[0m"  # ha egyezik, akkor jelezni a fájlok nevének kiírásával
                echo "A " ${fajlok[$m]}" elemet töröljük!"
                rm -Rfv  ${fajlok[$m]}
                echo ""
            fi
        fi
        done

done

echo ""
echo "Az azonos lapok törlése kész!"
echo ""

echo "A jpg formátum létrehozása"

cd ..

cp -R png jpg

cd jpg
mogrify -format jpg *.png
rm -Rfv *.png

echo ""
echo "A jpg verziós pdf összeállítása"
echo ""

convert *.jpg ujsag_jpg.pdf

echo "A jpg verziós pdf kész!"
echo ""
echo "Elkezdjük a png verziós pdf összeállítását!"

cd ..
cd png

convert *.png ujsag_png.pdf

echo ""
echo "A png verziós pdf kész!"
echo


echo "A script lefutott!"
echo ""
echo ""
