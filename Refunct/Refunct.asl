state("Refunct-Win32-Shipping")
{
    int   cubes               : 0x01F16C84, 0x61C, 0x9C;
    int   surfaces            : 0x01F16C84, 0x61C, 0xA0;
    int   level               : 0x01F16C84, 0x61C, 0xA8;
    int   resets              : 0x01F16C84, 0x61C, 0xAC;
    int   startSeconds        : 0x01F16C84, 0x61C, 0xB0;
    float startPartialSeconds : 0x01F16C84, 0x61C, 0xB4;
    int   endSeconds          : 0x01F16C84, 0x61C, 0xB8;
    float endPartialSeconds   : 0x01F16C84, 0x61C, 0xBC;
}

startup
{
    settings.Add("split_cubes", false, "Also split on cubes");
    settings.Add("custom_buttons", false, "Only split on some of the buttons");
    string[] splitnames = {
        "Start",
        "Edge Jump",
        "Detour Left",
        "Slide Under",
        "Superjump Up",
        "Elevator Jump",
        "Pipe Corner",
        "Water Elevator",
        "Another Elevator",
        "Pipe Jump",
        "Pre-Pit",
        "Pit",
        "Cornerjump Around",
        "Walljump Off",
        "Quickly Rising",
        "Corner Walljumps",
        "Quickly Rising Again",
        "An Elevator Again",
        "Leap of Faith",
        "Spiral",
        "Slide 'n' Stop",
        "Jump Across",
        "Two Walljumps",
        "Spring!",
        "Long Spring!",
        "Islands",
        "Spring Again",
        "Risers",
        "Long Walk",
        "Out the Window"
    };
    for (int i = 0; i < splitnames.Length; ++i) {
        int splitid = i + 1;
        settings.Add("split" + splitid, true, splitid + ": " + splitnames[i], "custom_buttons");
    }
}

start
{
    return current.resets > old.resets;
}

split
{
    if (current.resets > old.resets) return true;
    if (settings["split_cubes"] && current.cubes > old.cubes) return true;
    if (current.level > old.level && settings["split" + current.level]) return true;
    return false;
}

reset
{
    return current.resets > old.resets && current.level == 0;
}

gameTime
{
    if (current.endSeconds > current.startSeconds)
    {
        return TimeSpan.FromSeconds(
            Convert.ToDouble(current.endSeconds - current.startSeconds) +
            Convert.ToDouble(current.endPartialSeconds - current.startPartialSeconds)
        );
    }
}
