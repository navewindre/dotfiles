#! /usr/bin/env python

# v. 2.9
# Interactive subtitles for `mpv` for language learners.

#########################################
# all *_B variables are boolean
######

# make sure selected translation function supports your language and so that codes of your languages are correct
# for instance Pons doesn't support Hebrew, Google and Reverso do, but their codes are different: 'iw' and 'he' respectively
# translate from language
lang_from = 'ja'
# translate to language
lang_to = 'en'

# dictionaries to use, one or more
# or other function's name you might write that will return ([[word, translation]..], [morphology = '', gender = '']) # available:
#	jisho
#	google
#	tab_divided_dict - simple offline dictionary with word \t translation per line

# Online Usage:
translation_function_names = ['jisho', 'google']
# Offline Usage:
#translation_function_names = ['tab_divided_dict']

# for automatic switch to Hebrew. Skip if it isn't your language.
translation_function_names_2 = ['google']

# deepl/google
translation_function_name_full_sentence = 'google'

# number of translations in popup
number_of_translations = 4
# number of translations to save in files for each word; 0 - to save all
number_of_translations_to_save = 50

# gtts|pons|forvo # gtts is google-text-to-speech
listen_via = 'gtts'

# path to the offline dictionary
tab_divided_dict_fname = '~/.config/mpv/scripts/jaSubs/jp.dict'
# strip <.*?>
tab_divided_dict_remove_tags_B = True

pause_during_translation_B = True
# don't hide subtitle when its time is up and keep it on screen until the next line
extend_subs_duration2max_B = True
# limit extension duration in seconds; N == 0: do not limit
extend_subs_duration_limit_sec = 1
# show jaSubs only in fullscreen
hide_when_not_fullscreen_B = False

# interval between checking for the next subtitle; in seconds
update_time = .01
# interval in seconds between checking if mpv is in focus using `xdotool` and/or in fullscreen; in seconds
focus_checking_time = .2

# firefox "https://en.wiktionary.org/wiki/${word}"
show_in_browser = 'echo "${word}" | xclip -selection clipboard'

# for going through lines step by step
# skip pausing when subs are less then X words
auto_pause_min_words = 10
# 0 - don't pause
# 1 - pause after subs change
# 2 - pause before subs change
# wheel click on jaSubs cycles through options
auto_pause = 0

#########################################################
#########################################################
### LOOKS ###
#########################################################
#########################################################

# show subtitles at the top of the screen
subs_top_placement_B = False
# distance to the edge; in px
subs_screen_edge_padding = 70
subs_padding_between_lines = 0

# when subtitle consists of only one overly long line - splitting into two
split_long_lines_B = True
# split when there are more than N words in line
split_long_lines_words_min = 8
# split when there are more than N characters in line
split_long_lines_chars_min = 80

# Qt's line wrapping doesn't work well
split_long_lines_in_popup_B = True
# split when there are more than N symbols in given line
split_long_lines_in_popup_symbols_min = 80

# ~ http://doc.qt.io/qt-5/stylesheet-reference.html
'''
/* Examples of css: */

background: transparent;				/* fully transparent */
background: black;						/* black background*/
background: #ffffff;					/* white background*/
background: rgba(0, 0, 0, 20%);			/* semi-opaque black 20% */
background: rgba(0, 0, 0, 50%);			/* semi-opaque black 50% */
background: rgba(0, 0, 0, 80%);			/* semi-opaque black 80% */
background: rgba(255, 255, 255, 40%);	/* semi-opaque white 40% */
background: rgba(44, 44, 44, 90%);		/* semi-opaque dark-grey 90% */

/* Font colors: */
color: white;
color: #BAC4D6;
color: rgb(217, 49, 49);				/* red */
color: rgba(217, 49, 49, 70%);			/* semi-opaque red 70% */

font-family: "Trebuchet MS";
font-weight: bold;
font-size: 33px;

font: bold italic large "Times New Roman" 34px;

		font-family: "FiraGO";
		font-family: "Trebuchet MS";
		font-family: "American Typewriter";
'''

# CSS styles for subtitles
style_subs = '''
	/* looks of subtitles */
	QFrame {
		background: transparent;
		color: white;
		color: #FFF0CD;

		font-family: "American Typewriter";
		/* font-weight: bold; */
		font-size: 40px;
	}
'''

# CSS styles for translations(popup)
style_popup = '''
	/* main */
	QFrame {
		background: rgb(21, 22, 25);

		font-family: "Trebuchet MS";
		font-weight: regular;
		font-size: 32px;
	}
	/* original language */
	QLabel#first_line {
		color: #DCDCCC;
	}

	/* original language - underlining exact word */
	QLabel#first_line_emphasize_word {
		color: #DCDCCC;
		text-decoration: underline;
	}

	/* translation */
	QLabel#second_line {
		color: #8B8F88;
	}

	/* colorizing morphology */
	[morphology=""]		{ color: #e86969; }
	[morphology="m"]	{ color: #5EB0FF; }
	[morphology="f"]	{ color: #E34840; }
	[morphology="nt"]	{ color: #8BC34A; }

	/* delimiter between dictionaries */
	QFrame#delimiter {
		background: #8B8F88;
		font-size: 4px;	/* emulating thickness */
	}
'''

# for subtitles to be visible on background with similar color
# might look ugly with some fonts
outline_B = True
outline_color = '#000000'
# ~ N/2.5 == size in px; here it's 2px of outline + another ~ 3px of blur
outline_thickness = 5
outline_blur = 7
# change if outline is cropped from top/bottom of some letters depending on font
# in px; can take negative values
outline_top_padding = -2
outline_bottom_padding = 2

# highlighting the word under cursor
hover_color = '#F44336'
hover_hightlight = True	# may look ugly due to only int precision of QFontMetrics
hover_underline = False
hover_underline_thickness = 5

#########################################################
#########################################################
### reassigning mouse buttons ###
#########################################################
#########################################################

# functions' names are self-explanatory
# ['mouse_event', 'modifier_key', 'self_explanatory_function_name'],

# to one button multiple functions can be assigned
# by left-click this will open word in browser and save it to file.
# ['LeftButton', 'NoModifier', 'f_show_in_browser'],
# ['LeftButton', 'NoModifier', 'f_save_word_to_file'],

# https://doc.qt.io/qt-5/qt.html#MouseButton-enum
# mouse_event:
	# LeftButton
	# RightButton
	# MiddleButton (wheel-click)
	# BackButton (Typically present on the 'thumb' side of a mouse with extra buttons. This is NOT the tilt wheel.)
	# ForwardButton

	# wheel scroll up/down left/right names' are arbitrary and not from Qt
	# ScrollUp
	# ScrollDown
	# ScrollLeft (This is the tilt wheel.)
	# ScrollRight

# Note: On macOS, the ControlModifier value corresponds to the Command keys on the keyboard.
# https://doc.qt.io/qt-5/qt.html#KeyboardModifier-enum
# modifier_key:
	# NoModifier
	# ControlModifier
	# ShiftModifier
	# AltModifier

# self_explanatory_function_name:
	# f_show_in_browser
	# f_auto_pause_options
	# f_listen
	# f_scroll_translations_down
	# f_scroll_translations_up
	# f_subs_screen_edge_padding_decrease
	# f_subs_screen_edge_padding_increase
	# f_font_size_decrease
	# f_font_size_increase
	# f_auto_pause_min_words_decrease
	# f_auto_pause_min_words_increase
	# f_translation_full_sentence
	# f_save_word_to_file
	# f_deepl_translation < obsolete, changed into f_translation_full_sentence

mouse_buttons = [
	['LeftButton',		'NoModifier',		'f_show_in_browser'],
	['RightButton',		'NoModifier',		'f_copy_reading'],
	['MiddleButton',	'NoModifier',		'f_auto_pause_options'],

	['ScrollDown',		'ControlModifier',		'f_font_size_decrease'],
	['ScrollUp',		'ControlModifier',		'f_font_size_increase'],

	# ['ScrollLeft',		'NoModifier',		'f_auto_pause_min_words_decrease'],
	# ['ScrollRight',		'NoModifier',		'f_auto_pause_min_words_increase'],

	['ScrollDown',		'ShiftModifier',		'f_subs_screen_edge_padding_decrease'],
	['ScrollUp',		'ShiftModifier',		'f_subs_screen_edge_padding_increase'],
]

# obsolete vars
hover_underline_width = hover_underline_thickness
