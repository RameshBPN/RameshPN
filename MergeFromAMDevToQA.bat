cd c:\
rd c:\MergeFromAMDevToQA /s /q
mkdir MergeFromAMDevToQA
cd c:\MergeFromAMDevToQA
git init
git clone https://github.com/RameshBPN/RameshPN.git
cd c:\MergeFromAMDevToQA\RameshPN
git config --global user.email "ramesh.botlaggunta@gmail.com"
git config --global user.name "RameshBPN"
git config remote.origin.url https://RameshBPN:1987oct17@github.com/RameshBPN/RameshPN.git
git checkout AMDev
git checkout QA
git merge AMDev
git push origin HEAD

