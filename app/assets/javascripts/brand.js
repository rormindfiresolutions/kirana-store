var ready;

ready = function() {
	$("#product_brand_id").change(function(){
		if($("#product_brand_id>option:selected").html() == 'Others'){
		  $('#add-brand').show();
		}
		else {
		  $('#add-brand').hide();
		}
	});

	$("#product_category_id").change(function(){
		if($("#product_category_id>option:selected").html() == 'Miscellaneous'){
		  $('#add-category').show();
		}
		else {
		  $('#add-category').hide();
		}
	});
};

$(document).ready(ready);
$(document).on('page:load', ready);
