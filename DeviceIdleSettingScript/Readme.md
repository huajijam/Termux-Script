### Android Device System Idle Setting Script
- (DeviceidleSettingScript.sh)
***
为Rooted Android设备提供基于termux/Android Shell的自更改式脚本  用于写入dumpsys deviceidel whitelist参数更改电池优化名单  
```bash
Usage:
   ./DeviceidleSettingScript.sh --Option <package>
Options:
    -add # Write a add package to the script
    -remove # Write a remove package from the script
    -delete # Delete a package from the script
    -list # Show all packages in the script
    --get-all # Get all packages that was added
    --run-only # Only run command but not adding in the script
    (e.g. './DeviceidleSettingScript.sh --run-only +<package>')
    --add-only # Only add package but not running this time
    --remove-only # Only remove package but not running this time
    --version # Print Version of this script
```
