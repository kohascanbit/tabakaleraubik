</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="generator" content="Koha [% Bertsioa %]" /> <!-- leave this for stats -->
<link rel="shortcut icon" href="[% IF ( OpacFavicon ) %][% OpacFavicon %][% ELSE %][% themelang %]/includes/favicon.ico[% END %]" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="[% themelang %]/lib/jquery/jquery-ui.css" />
<link rel="stylesheet" type="text/css" href="/opac-tmpl/lib/yui/reset-fonts-grids.css" />
<link rel="stylesheet" type="text/css" href="/opac-tmpl/lib/yui/skin.css" />
[% SET opaclayoutstylesheet='opac.css' UNLESS opaclayoutstylesheet %] [% IF (opaclayoutstylesheet.match('^https?:|^\/')) %] <link rel="stylesheet" type="text/css" href="[% opaclayoutstylesheet %]" />
[% ELSE %] <link rel="stylesheet" type="text/css" href="[% themelang %]/css/[% opaclayoutstylesheet %]" />
[% END %] [% IF ( opaccolorstylesheet ) %] [% IF (opaccolorstylesheet.match('^https?:|^\/')) %] <link rel="stylesheet" type="text/css" href="[% opaccolorstylesheet %]" />
 [% ELSE %] <link rel="stylesheet" type="text/css" href="[% themelang %]/css/[% opaccolorstylesheet %]" />
 [% END %] [% END %] [% IF ( opac_css_override ) %] <link rel="stylesheet" type="text/css" href="[% themelang %]/css/[% opac_css_override %]" />
[% END %] <link rel="stylesheet" type="text/css" media="print" href="[% themelang %]/css/print.css" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
<link rel="stylesheet" type="text/css" media="screen and (max-width:700px)" href="[% themelang %]/css/mobile.css" />
[% IF ( bidi ) %] <link rel="stylesheet" type="text/css" href="[% themelang %]/css/right-to-left.css" />
[% END %] [% IF ( OPACMobileUserCSS ) %]<style type="text/css" media="screen and (max-width:700px)">[% OPACMobileUserCSS %]</style>[% END %] [% IF ( OPACUserCSS ) %]<style type="text/css">[% OPACUserCSS %]</style>[% END %] [% IF persona %] <link rel="stylesheet" type="text/css" href="[% themelang %]/css/persona-buttons.css" />
[% END %]

<!-- yui js -->
<script type="text/javascript" src="[% yuipath %]/utilities/utilities.js"></script>
<script type="text/javascript" src="[% yuipath %]/container/container-min.js"></script>
<script type="text/javascript" src="[% yuipath %]/menu/menu-min.js"></script>
<script type="text/javascript" src="[% themelang %]/lib/jquery/jquery.js"></script>
<script type="text/javascript" src="[% themelang %]/lib/jquery/jquery-ui.js"></script>
<script type="text/javascript" src="[% themelang %]/lib/jquery/plugins/jquery.hoverIntent.minified.js"></script>
<script type="text/javascript" src="[% themelang %]/js/script.js"></script>
[% IF ( OPACAmazonCoverImages ) %] <script type="text/javascript">//<![CDATA[
    var NO_AMAZON_IMAGE = _("Ez dago irudirik");
//]]>
</script>
<script type="text/javascript" src="[% themelang %]/js/amazonimages.js"></script>
[% END %] [% IF ( SyndeticsCoverImages ) %] <script type="text/javascript">//<![CDATA[
        var NO_AMAZON_IMAGE = _("Ez dago irudirik");
    //]]>
</script>
<script type="text/javascript" src="[% themelang %]/js/amazonimages.js"></script> [% END %] [% IF ( opacbookbag ) %]<script type="text/javascript" src="[% themelang %]/js/basket.js">
[% ELSIF ( virtualshelves ) %]<script type="text/javascript" src="[% themelang %]/js/basket.js">
[% ELSE %]<script type="text/javascript"> var readCookie;[% END %]
</script>

<script type="text/javascript">
//<![CDATA[
    [% IF ( opacbookbag ) %]var MSG_BASKET_EMPTY = _("Zure saskia hutsik dago");
    var MSG_RECORD_IN_BASKET = _("Item hau jadanik zure saskian dago");
    var MSG_RECORD_ADDED = _("Item hau zure saskian sartu da");
    var MSG_RECORD_REMOVED = _("This item has been removed from your cart");
    var MSG_NRECORDS_ADDED = _("  zure saski(eta)ra gehitutako item(ak)");
    var MSG_NRECORDS_IN_BASKET = _("dagoeneko zure saskian dago");
    var MSG_NO_RECORD_SELECTED = _("Ez da itemik aurkitu");
    var MSG_NO_RECORD_ADDED = _("Ez da itemik sartu zure saskian");
    var MSG_CONFIRM_DEL_BASKET = _("Ziur zaude zure saskia hustu nahi duzula ?");
    var MSG_CONFIRM_DEL_RECORDS = _("Ziur zaude aukeratutako itemak ezabatu nahi dituzula?");
    var MSG_ITEM_IN_CART = _("In your cart");
    var MSG_IN_YOUR_CART = _("Items in your cart: ");
    var MSG_ITEM_NOT_IN_CART = _("Add to your cart");
      $("#cartDetails").ready(function(){ $("#cmspan").html("<a href=\"#\" id=\"cartmenulink\" class=\"\"><span> "+_("Saskia")+"<span id=\"basketcount\"><\/span><\/span><\/a>"); });
    [% ELSE %][% IF ( virtualshelves ) %]
    var MSG_NO_RECORD_SELECTED = _("Ez da itemik aurkitu");[% END %][% END %]
    [% IF ( opacuserlogin ) %][% IF ( TagsEnabled ) %]var MSG_TAGS_DISABLED = _("Sentitzen dugu, etiketak ez daude gaituta sistema honetan");
    var MSG_TAG_ALL_BAD = _("Zure etiketak kode ilegala zeukan. EZ da gehitu. Saiatu berriro testu lauarekin. ");
    var MSG_ILLEGAL_PARAMETER = _("Errorea! Parametro ilegala");
    var MSG_TAG_SCRUBBED = _("Oharra: zeure etiketak ezabatu den kodea zeukan. Etiketa honela gehitua izan da");
    var MSG_ADD_TAG_FAILED = _("Errorea! add_tag eragiketak huts egin du");
    var MSG_ADD_TAG_FAILED_NOTE = _("Oharra: termino jakin batekin item bakarra etiketatu dezakezu. Bistaratu ‘Nire etiketak’ zure uneko etiketak ikusteko");
    var MSG_DELETE_TAG_FAILED = _("Errorea! Ezin duzu txartela ezabatu");
    var MSG_DELETE_TAG_FAILED_NOTE = _("Oharra: zeure etiketak baino ezin dituzu ezabatu. ")
    var MSG_LOGIN_REQUIRED = _("Etiketak sartzeko zure kontuarekin sartu behar duzu. ");
    var MSG_TAGS_ADDED = _("Gehitutako etiketak: ");
    var MSG_TAGS_DELETED = _("Gehitutako etiketak: ");
    var MSG_TAGS_ERRORS = _("Erroreak:");
    var MSG_MULTI_ADD_TAG_FAILED = _("Etiketa bat edo gehiago ezin izan dira gehitu");
    var MSG_NO_TAG_SPECIFIED = _("No tag was specified.");[% END %][% END %]
    [% IF ( OPACAmazonCoverImages ) %]$(window).load(function() {
        verify_images();
    });[% END %]
    [% IF ( SyndeticsCoverImages ) %]$(window).load(function() {
            verify_images();
         });[% END %]
//]]>
[% IF ( opacbookbag ) %]</script><script type="text/javascript" src="[% themelang %]/js/basket.js">
[% ELSIF ( virtualshelves ) %]</script><script type="text/javascript" src="[% themelang %]/js/basket.js">
[% ELSE %]</script><script type="text/javascript">var readCookie;[% END %]</script>
[% IF ( opacuserlogin ) %][% IF ( TagsEnabled ) %]<script type="text/javascript" src="[% themelang %]/js/tags.js"></script>[% END %][% ELSE %][% END %] [% IF ( GoogleJackets ) %] <script type="text/javascript" src="[% themelang %]/js/google-jackets.js"></script>
<script type="text/javascript">
//<![CDATA[
    var NO_GOOGLE_JACKET = _("Ez dago irudirik");
//]]>
</script>
[% END %] [% IF OpenLibraryCovers %] <script type="text/javascript" src="[% themelang %]/js/openlibrary.js"></script>
<script type="text/javascript">
//<![CDATA[
var NO_OL_JACKET = _("Ez dago irudirik");
//]]>
</script>
[% END %] [% IF OPACLocalCoverImages %] <script type="text/javascript" src="[% themelang %]/js/localcovers.js"></script>
<script type="text/javascript">
//<![CDATA[
var NO_LOCAL_JACKET = _("Ez dago irudirik");
//]]>
</script>
[% END %] [% IF ( BakerTaylorEnabled ) %]<script type="text/javascript" src="[% themelang %]/js/bakertaylorimages.js"></script>
<script type="text/javascript">
//<![CDATA[
    var NO_BAKERTAYLOR_IMAGE = _("Ez dago irudirik");
    $(window).load(function(){
        bt_verify_images();
    });
//]]>
</script>[% END %] <link rel="unapi-server" type="application/xml" title="unAPI" href="[% OPACBaseURL %]/cgi-bin/koha/unapi" />
[% IF ( GoogleIndicTransliteration ) %] <script type="text/javascript" src="http://www.google.com/jsapi"></script>
 <script type="text/javascript" src="[% themelang %]/js/googleindictransliteration.js"></script>
[% END %] 