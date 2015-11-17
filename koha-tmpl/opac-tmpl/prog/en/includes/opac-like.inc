<div class="is-aui" id="purchase-sims-feature">
<a name="purchase"></a>

<hr size="1" noshade="true" class="bucketDivider">
<div class="bucket a-section a-spacing-extra-large">
<div class="simsWrapper">

<div id="purchaseShvl" class="shoveler">
    <div class="shoveler-heading">
        <h2>If you liked this, you may be interested</h2>
    </div>

<div id="purchaseButtonWrapper" class="shoveler-button-wrapper">
    <ul tabindex="-1" id="others">
    
	[% FOREACH SUGGESTION IN SUGGESTION_LIST %]
		<li class="shoveler-cell">

			<a class="sim-img-title" href="/cgi-bin/koha/opac-detail.pl?biblionumber=[% SUGGESTION.biblionumber %]"> 
			<div class="product-image">
               <img width="70" height="90" border="0" alt="" src="/cgi-bin/koha/opac-image.pl?thumbnail=1&biblionumber=[% SUGGESTION.biblionumber %]">
            </div>
            <span title="[% SUGGESTION.title %]">[% SUGGESTION.title %]</span> </a>

		    <div class="byline">
		        [% SUGGESTION.author %]
		    </div>
		</li>
	
	[% END %]

    </ul>
</div>

</div>
</div>
</div>