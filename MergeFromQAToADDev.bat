cd c:\
rd c:\MergeFromQAToADDev /s /q
mkdir MergeFromQAToADDev
cd c:\MergeFromQAToADDev
git init
git clone https://github.com/RameshBPN/RameshPN.git
cd c:\MergeFromQAToADDev\RameshPN
git config --global user.email "ramesh.botlaggunta@gmail.com"
git config --global user.name "RameshBPN"
git config remote.origin.url https://RameshBPN:1987oct17@github.com/RameshBPN/RameshPN.git
git checkout QA
git checkout ADDev
git merge QA
git push origin HEAD
