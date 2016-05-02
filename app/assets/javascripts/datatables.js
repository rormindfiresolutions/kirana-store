var ready;

ready = function() {
  $('#users').dataTable({
    processing: true,
    serverSide: true,
    ajax: $('#users').data('source'),
    pagingType: 'full_numbers',
    oLanguage: {
       sLengthMenu: "_MENU_",
    },
    columns: [
      { searchable: true, orderable: true }, 
      { searchable: true, orderable: true },
      { searchable: false, orderable: false },
      { searchable: false, orderable: false }
    ],
  });

  $('#shop_profiles').dataTable({
    processing: true,
    serverSide: true,
    ajax: $('#shop_profiles').data('source'),
    pagingType: 'full_numbers',
    oLanguage: {
       sLengthMenu: "_MENU_",
    },
    columns: [
      { searchable: true, orderable: true },
      { searchable: true, orderable: true }, 
      { searchable: false, orderable: false },
      { searchable: false, orderable: false },
      { searchable: false, orderable: false }
    ],
  });

  $('#products').dataTable({
    processing: true,
    serverSide: true,
    ajax: $('#products').data('source'),
    pagingType: 'full_numbers',
    oLanguage: {
       sLengthMenu: "_MENU_",
    },
    columns: [ 
      { searchable: true, orderable: true },
      { searchable: false, orderable: false },
      { searchable: false, orderable: false }  
    ] 
  });

  $('#user_baskets').dataTable({
    processing: true,
    serverSide: true,
    ajax: $('#user_baskets').data('source'),
    pagingType: 'full_numbers',
    oLanguage: {
       sLengthMenu: "_MENU_",
    },
    columns: [ 
      { searchable: true, orderable: true },
      { searchable: false, orderable: false },
      { searchable: false, orderable: false },
      { searchable: false, orderable: false },
      { searchable: false, orderable: false } 
    ] 
  });

  $('#shop_products').dataTable({
    processing: true,
    serverSide: true,
    ajax: $('#shop_products').data('source'),
    pagingType: 'full_numbers',
    oLanguage: {
       sLengthMenu: "_MENU_",
    },
    columns: [
      { searchable: true, orderable: true }, 
      { searchable: false, orderable: false },
      { searchable: false, orderable: false },
      { searchable: false, orderable: false }
    ],
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
