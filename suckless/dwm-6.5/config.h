#include <X11/XF86keysym.h>

/*
#define XF86AudioLowerVolume 0xffc3
#define XF86AudioMute 0xffc2
#define XF86AudioRaiseVolume 0xffc4
*/

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "DroidSansMono:size=16" };
static const char dmenufont[]       = "DroidSansMono:size=16";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char thunder_blue[]    = "#90ffff";
static const char sky_red[]         = "#ff5550";
static const char col_gray4[]       = "#eeeeee";
static const char castlepink[]      = "#feafa8";
static const char castlegreen[]     = "#010113";
static const char castlemoon[]      = "#f5fded";
static const char white[]           = "#ffffff";

static const char *colors[][3]      = {
	/*               fg          bg           border   */
	[SchemeNorm] = { castlepink, castlegreen, castlegreen},
	[SchemeSel]  = { castlemoon, castlegreen, castlegreen},
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };


static const Rule rules[] = {
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "tiling",      tile },    /* first entry is default */
	{ "floating", NULL },    /* no layout function means floating behavior */
	{ "monocle",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */

/* define keybinds */
// dmenu
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", castlegreen, "-nf", thunder_blue, "-sb", col_gray1, "-sf", sky_red, NULL };

// terminal, browser
static const char *termcmd[]  = { "st", NULL };
static const char *braveincogcmd[]  = { "brave", "--incognito", NULL };
static const char *bravecmd[]  = { "brave", NULL };

// shutdown, reboot
static const char *shutdowncmd[]  = { "systemctl", "poweroff", NULL };
static const char *rebootcmd[] = {"systemctl", "reboot", NULL};

// brightness +/-
static const char *brightmin[]  = { "brightnessctl", "set", "1", NULL };
static const char *brightplus[]  = { "brightnessctl", "set", "+1%", NULL };
static const char *brightminus[]  = { "brightnessctl", "set", "1%-", NULL };

// screenshot (copy/save)
static const char *clipboard[] = { "/bin/sh", "-c", "maim | xclip -selection clipboard -t image/png", NULL };
static const char *save[] = { "/bin/sh", "-c", "maim ~/Pictures/$(date +%F-%H_%M_%S).png", NULL };

// volume
static const char *volumeplus[]  = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%", NULL };
static const char *volumeminus[]  = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%", NULL };
static const char *volumemute[]  = { "pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", NULL };

// file manager (thunar)
static const char *filemgr[]  = { "thunar", ".", NULL };

// keybinds
static const Key keys[] = {
	/* modifier                     key                     function        argument */
	{ MODKEY,                       XK_d,                   spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_Return,              spawn,          {.v = termcmd } },

	{ MODKEY,                       XK_b,                   spawn,          {.v = bravecmd} },
	{ MODKEY|ShiftMask,             XK_i,                   spawn,          {.v = braveincogcmd } },
	{ Mod1Mask,                     XK_s,                   spawn,          {.v = shutdowncmd} },
	{ Mod1Mask,                     XK_r,                   spawn,          {.v = rebootcmd} },

	{ Mod1Mask|ShiftMask,           XK_m,                   spawn,          {.v = brightmin} },
	{ Mod1Mask,                     XK_equal,               spawn,          {.v = brightplus} },
	{ Mod1Mask,                     XK_minus,               spawn,          {.v = brightminus} },

	{ 0,                         XF86XK_AudioRaiseVolume,   spawn,          {.v = volumeplus} },
	{ 0,                         XF86XK_AudioLowerVolume,   spawn,          {.v = volumeminus} },
	{ 0,                         XF86XK_AudioMute,          spawn,          {.v = volumemute} },

	{ ControlMask,                  XK_p,                   spawn,          {.v = clipboard} },
	{ MODKEY,                       XK_p,                   spawn,          {.v = save} },

	{ MODKEY,                       XK_e,                   spawn,          {.v = filemgr} },
	
	{ MODKEY|ShiftMask,             XK_b,                   togglebar,      {0} },
	{ MODKEY,                       XK_j,                   focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,                   focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,                   incnmaster,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_d,                   incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,                   setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,                   setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Tab,                 view,           {0} },
	{ MODKEY|ShiftMask,             XK_q,                   killclient,     {0} },
	{ MODKEY,                       XK_t,                   setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,                   setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,                   setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,               setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,               togglefloating, {0} },
	{ MODKEY,                       XK_0,                   view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,                   tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,               focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period,              focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,               tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,              tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                                   0)
	TAGKEYS(                        XK_2,                                   1)
	TAGKEYS(                        XK_3,                                   2)
	TAGKEYS(                        XK_4,                                   3)
	TAGKEYS(                        XK_5,                                   4)
	TAGKEYS(                        XK_6,                                   5)
	TAGKEYS(                        XK_7,                                   6)
	TAGKEYS(                        XK_8,                                   7)
	TAGKEYS(                        XK_9,                                   8)
	{ MODKEY|ShiftMask,             XK_c,                   quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
