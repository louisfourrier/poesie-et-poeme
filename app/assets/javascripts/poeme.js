$(function() {

	$(window).scroll(function() {
		if ($(this).scrollTop() >= 50) {// If page is scrolled more than 50px
			$('#return-to-top').fadeIn(200);
			// Fade in the arrow
		} else {
			$('#return-to-top').fadeOut(200);
			// Else fade out the arrow
		}
	});
	$('#return-to-top').click(function() {// When arrow is clicked
		$('body,html').animate({
			scrollTop : 0 // Scroll to top of body
		}, 500);
	});
	
	

});

$(document).ready(function() {
    $('.dataTable').DataTable({
    	paging: false,
    	language: {
        processing:     "Traitement en cours...",
        search:         "Rechercher&nbsp;:",
        lengthMenu:    "Afficher _MENU_ &eacute;l&eacute;ments",
        info:           "Affichage de l'&eacute;lement _START_ &agrave; _END_ sur _TOTAL_ &eacute;l&eacute;ments",
        infoEmpty:      "Affichage de l'&eacute;lement 0 &agrave; 0 sur 0 &eacute;l&eacute;ments",
        infoFiltered:   "(filtr&eacute; de _MAX_ &eacute;l&eacute;ments au total)",
        infoPostFix:    "",
        loadingRecords: "Chargement en cours...",
        zeroRecords:    "Aucun &eacute;l&eacute;ment &agrave; afficher",
        emptyTable:     "Aucune donnée disponible dans le tableau",
        paginate: {
            first:      "Premier",
            previous:   "Pr&eacute;c&eacute;dent",
            next:       "Suivant",
            last:       "Dernier"
        },
        aria: {
            sortAscending:  ": activer pour trier la colonne par ordre croissant",
            sortDescending: ": activer pour trier la colonne par ordre décroissant"
        }
    }
    });
} );