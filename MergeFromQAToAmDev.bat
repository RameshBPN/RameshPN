cd c:\
rd c:\MergeFromQAToAmDev /s /q
mkdir MergeFromQAToAmDev
cd c:\MergeFromQAToAmDev
git init
git clone https://github.com/RameshBPN/RameshPN.git
cd c:\MergeFromQAToAmDev\RameshPN
git config --global user.email "ramesh.botlaggunta@gmail.com"
git config --global user.name "RameshBPN"
git config remote.origin.url https://RameshBPN:1987oct17@github.com/RameshBPN/RameshPN.git
git checkout QA
git checkout AMDev
git merge QA
git push origin HEAD
