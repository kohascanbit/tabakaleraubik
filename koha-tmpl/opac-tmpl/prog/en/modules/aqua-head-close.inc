</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="generator" content="Koha [% Version %]" /> <!-- leave this for stats -->
<link rel="shortcut icon" href="[% IF ( OpacFavicon ) %][% OpacFavicon %][% ELSE %][% themelang %]/includes/favicon.ico[% END %]" type="image/x-icon" />[% IF ( opacstylesheet ) %]<link rel="stylesheet" type="text/css" href="[% opacstylesheet %]" />[% ELSE %] [% IF ( opaclayoutstylesheet ) %]<link rel="stylesheet" type="text/css" href="[% themelang %]/cssaqua/[% opaclayoutstylesheet %]" />[% ELSE %]<link rel="stylesheet" type="text/css" href="[% themelang %]/cssaqua/opac.css" />[% END %][% END %] [% IF ( opaccolorstylesheet ) %] <link rel="stylesheet" type="text/css" href="[% themelang %]/cssaqua/[% opaccolorstylesheet %]" />[% END %] [% IF ( opacexternalsheet ) %] <link rel="stylesheet" type="text/css" href="[% opacexternalsheet %]" />[% END %] [% IF ( opac_css_override ) %] <link rel="stylesheet" type="text/css" href="[% themelang %]/cssaqua/[% opac_css_override %]" />[% END %] <link rel="stylesheet" type="text/css" media="print" href="[% themelang %]/cssaqua/print.css" />
<link rel="stylesheet" type="text/css" href="[% themelang %]/lib/jquery/plugins/ui.tabs.css" />[% IF ( OPACUserCSS ) %]<style type="text/css">[% OPACUserCSS %]</style>[% END %]
<!-- yui js --> 
<script type="text/javascript" src="[% yuipath %]/utilities/utilities.js"></script> 
<script type="text/javascript" src="[% yuipath %]/container/container-min.js"></script> 
<script type="text/javascript" src="[% yuipath %]/menu/menu-min.js"></script> 
<script type="text/javascript" src="[% themelang %]/lib/jquery/jquery.js"></script>
<script type="text/javascript" src="[% themelang %]/lib/jquery/plugins/ui.tabs.js"></script>
<script type="text/javascript" src="[% themelang %]/lib/jquery/plugins/jquery.hoverIntent.minified.js"></script>
<script type="text/javascript" language="javascript" src="[% themelang %]/js/script.js"></script>[% IF ( OPACAmazonCoverImages ) %] <script type="text/javascript" language="javascript">//<![CDATA[
		var NO_AMAZON_IMAGE = _("No hay imagen de portada disponible");
	//]]>
</script>
<script type="text/javascript" language="javascript" src="[% themelang %]/js/amazonimages.js"></script>[% END %] [% IF ( SyndeticsCoverImages ) %] <script type="text/javascript" language="javascript">//<![CDATA[
        var NO_AMAZON_IMAGE = _("No hay imagen de portada disponible");
    //]]>
</script>
<script type="text/javascript" language="javascript" src="[% themelang %]/js/amazonimages.js"></script>[% END %] <script type="text/javascript" language="javascript"
[% IF ( opacbookbag ) %]src="[% themelang %]/js/basket.js">[% ELSIF ( virtualshelves ) %]src="[% themelang %]/js/basket.js">[% ELSE %]>var readCookie;[% END %]</script>
<script type="text/javascript" language="javascript">
	//<![CDATA[
    [% IF ( opacbookbag ) %]var MSG_BASKET_EMPTY = _("Su cesta está vacía actualmente");
    var MSG_RECORD_IN_BASKET = _("Este ítem ya está en su cesta");
    var MSG_RECORD_ADDED = _("Este ítem se agregó a su cesta");
    var MSG_NRECORDS_ADDED = _(" ítem(s) añadidos a tu cesta");
    var MSG_NRECORDS_IN_BASKET = _("ya está en su cesta");
    var MSG_NO_RECORD_SELECTED = _("No se seleccionó ningún ítem");
    var MSG_NO_RECORD_ADDED = _("No se agregaron items a su cesta");
    var MSG_CONFIRM_DEL_BASKET = _("¿Está seguro de querer vaciar su cesta?");
    var MSG_CONFIRM_DEL_RECORDS = _("¿Está seguro de querer borrar los ítems seleccionados?");
	$("#cartDetails").ready(function(){ $("#cmspan").html("<a href=\"#\" id=\"cartmenulink\" class=\"\"><i><\/i><span><i><\/i><span><\/span><span id=\"carticon\"></span> "+_("Cesta")+"<span id=\"basketcount\"><\/span><\/span><\/a>"); }); [% ELSE %][% IF ( virtualshelves ) %]
    var MSG_NO_RECORD_SELECTED = _("No se seleccionó ningún ítem");[% END %][% END %]
    [% IF ( opacuserlogin ) %][% IF ( TagsEnabled ) %]var MSG_TAGS_DISABLED = _("Lo sentimos, las etiquetas no están habilitadas en este sistema.");
    var MSG_TAG_ALL_BAD = _("Error! Su etiqueta tenía código ilegal. NO ha sido agregada. Inténtelo de nuevo con texto plano.");
    var MSG_ILLEGAL_PARAMETER = _("¡Error! Parámetro ilegal");
    var MSG_TAG_SCRUBBED = _("Nota: su etiqueta contenía código que fue borrado. La etiqueta fue agregada como ");
    var MSG_ADD_TAG_FAILED = _("¡Error! La operacion add_tag falló en");
    var MSG_ADD_TAG_FAILED_NOTE = _("Nota: solo puede etiquetar un ítem con determinado término una vez. Vea 'Mis Etiquetas' para ver sus etiquetas actuales.");
    var MSG_DELETE_TAG_FAILED = _("¡Error! No puede borrar la etiqueta");
    var MSG_DELETE_TAG_FAILED_NOTE = _("Nota: sólo puede borrar sus propias etiquetas.")
    var MSG_LOGIN_REQUIRED = _("Debe acceder a su cuenta para agregar etiquetas.");
    var MSG_TAGS_ADDED = _("Etiquetas agregadas: ");
    var MSG_TAGS_DELETED = _("Etiquetas agregadas: ");
    var MSG_TAGS_ERRORS = _("Errores: ");
    var MSG_MULTI_ADD_TAG_FAILED = _("No se pudo agregar una o más etiquetas.");[% END %][% END %]
	[% IF ( OPACAmazonCoverImages ) %]$(window).load(function() {
		 	verify_images();
		 });[% END %]
	[% IF ( SyndeticsCoverImages ) %]$(window).load(function() {
            verify_images();
         });[% END %]
	[% IF ( opacuserjs ) %][% opacuserjs %][% END %]
	//]]>
</script><script type="text/javascript" language="javascript"
[% IF ( opacbookbag ) %]src="[% themelang %]/js/basket.js">[% ELSIF ( virtualshelves ) %]src="[% themelang %]/js/basket.js">[% ELSE %]>var readCookie;[% END %]</script>[% IF ( opacuserlogin ) %][% IF ( TagsEnabled ) %]<script type="text/javascript" language="javascript" src="[% themelang %]/js/tags.js"></script>[% END %][% ELSE %][% END %] [% IF ( GoogleJackets ) %] <script type="text/javascript" language="javascript" src="[% themelang %]/js/google-jackets.js"></script>
<script type="text/javascript" language="javascript">
	//<![CDATA[
	var NO_GOOGLE_JACKET = _("No hay imagen de portada disponible");
	//]]>
</script>[% END %][% IF ( BakerTaylorEnabled ) %]<script type="text/javascript" language="javascript" src="[% themelang %]/js/bakertaylorimages.js"></script>
<script type="text/javascript" language="javascript">
	//<![CDATA[
	var NO_BAKERTAYLOR_IMAGE = _("No hay imagen de portada disponible");
	$(window).load(function(){
		bt_verify_images();
	});
	//]]>
</script>[% END %] <link rel="unapi-server" type="application/xml" title="unAPI" href="[% OPACBaseurl %]/cgi-bin/koha/unapi" />[% IF ( GoogleIndicTransliteration ) %] <script type="text/javascript" src="http://www.google.com/jsapi"></script>
 <script type="text/javascript" language="javascript" src="[% themelang %]/js/googleindictransliteration.js"></script>
[% END %]
<!--[if IE]>
<link rel="stylesheet" href="[% themelang %]/cssaqua/ie_only.css" type="text/css" />
<![endif]--> 
<!--[if IE 7]>
<link rel="stylesheet" href="[% themelang %]/cssaqua/ie7.css" type="text/css" />
<![endif]-->
