$(document).on('turbolinks:load', function(){
  
  $('#image-input').on('change', function(e){
    if($("#error-image")){
      let errorImage = $("#error-image")
      errorImage.text("");
    }
    //ファイルオブジェクトを取得する
    let files = e.target.files;
    $.each(files, function(index, file) {
      let reader = new FileReader();

      //画像でない場合は処理終了
      if(file.type.indexOf("image") < 0){
        alert("画像ファイルを指定してください。");
        return false;
      }
      //アップロードした画像を設定する
      reader.onload = (function(file){
        return function(e){
          let imageLength = $('#output-box').children('h1').length;
          // 表示されているプレビューの数を数える

          let labelLength = $("#image-input>label").eq(-1).data('label-id');
          // #image-inputの子要素labelの中から最後の要素のカスタムデータidを取得

          // プレビュー表示
          $('#image-input').before(`<h1 id="check${labelLength}"></h1>
                                    <li class="preview-image" id="upload-image${labelLength}" data-image-id="${labelLength}">
                                      <figure class="preview-image__figure">
                                        <img src='${e.target.result}' alt='${file.name}' >
                                      </figure>
                                      <div class="preview-image__button">
                                        <a class="preview-image__button__edit">編集</a>
                                        <a class="preview-image__button__delete" data-image-id="${labelLength}">削除</a>
                                      </div>
                                    </li>`);
          $("#image-input>label").eq(-1).css('display','none');
          // 入力されたlabelを見えなくする

          if (imageLength < 9) {
            // 表示されているプレビューが９以下なら、新たにinputを生成する
            $("#image-input").append(`<label for="item_images${labelLength+1}" class="sell-container__content__upload__items__box__label" data-label-id="${labelLength+1}">
                                        <input multiple="multiple" class="sell-container__content__upload__items__box__input" id="item_images${labelLength+1}" style="display: none;" type="file" name="item[images][]">
                                        <i class="fas fa-camera fa-lg"></i>
                                      </label>`);
          };
        };
      })(file);
      reader.readAsDataURL(file);
    });
  });

  

  //削除ボタンが押された時
  $('#output-box').on('click', '.preview-image__button__delete', function(){
    let targetImageId = $(this).data('image-id');
    // イベント元のカスタムデータ属性の値を取得
    $(`#upload-image${targetImageId}`).remove();
    //プレビューを削除
    $(`[for=item_images${targetImageId}]`).remove();
    //削除したプレビューに関連したinputを削除
    $(`#check${targetImageId}`).remove();
    let imageLength = $('#output-box').children('h1').length;
    // 表示されているプレビューの数を数える
    if (imageLength ==9) {
      let labelLength = $("#image-input>label").eq(-1).data('label-id');
      // 表示されているプレビューが９なら,#image-inputの子要素labelの中から最後の要素のカスタムデータidを取得
      $("#image-input").append(`<label for="item_images${labelLength+1}" class="sell-container__content__upload__items__box__label" data-label-id="${labelLength+1}">
                                  <input multiple="multiple" class="sell-container__content__upload__items__box__input" id="item_images${labelLength+1}" style="display: none;" type="file" name="item[images][]">
                                  <i class="fas fa-camera fa-lg"></i>
                                </label>`);
    };
  });

  // f.text_areaの文字数カウント
  $("textarea").keyup(function(){
    let txtcount = $(this).val().length;
    $("#word-count").text(txtcount);
  });

  //販売価格入力時の手数料計算
  $('#item_price').keyup(function(){
    let price= $(this).val();
    if (price >= 300 && price <= 9999999){
      let fee = Math.floor(price * 0.1);
      // 小数点以下切り捨て
      let profit = (price - fee);
      $('.sell-container__content__commission__right').text('¥'+fee.toLocaleString());
      // 対象要素の文字列書き換える
      $('.sell-container__content__profit__right').text('¥'+profit.toLocaleString());
    } else{
      $('.sell-container__content__commission__right').html('ー');
      $('.sell-container__content__profit__right').html('ー');
    }
  });

  $(function(){
    // カテゴリーセレクトボックスのオプションを作成
    function genreOption(genre){
      var optionHtml = `<option value="${genre.id}">${genre.name}</option>`;
      return optionHtml;
    }
    // 親カテゴリー選択後のイベント
    $('#genre-select').on('change', function(){
      let parentGenreId = $(this).val();
      //選択された親カテゴリーのIDを取得
      if (parentGenreId == ''){
        //親カテゴリーが空（初期値）の時
        $('#select-children-box').remove();
        $('#select-grandchildren-box').remove();
        //子と孫を削除する
      }else{
        $.ajax({
          url: '/items/genre_children',
          type: 'GET',
          data: { parent_id: parentGenreId },
          dataType: 'json'
        })
        .done(function(genre_children){
          $('#select-children-box').remove();
          $('#select-grandchildren-box').remove();
          //親が変更された時、子と孫を削除する
          let optionHtml = '';
          genre_children.forEach(function(child){
            optionHtml += genreOption(child);
            //option要素を作成する
          });
          $('#error-genre').before(`<div class="sell-collection_select " id="select-children-box">
                                          <label class="sell-collection_select__label" for="item_genre_id">
                                            <select class="sell-collection_select__input" id="genre-select-children" required="required" name="item[genre_id]">
                                              <option value="">選択して下さい</option>
                                              ${optionHtml}
                                            </select>
                                            <i class="fas fa-chevron-down"></i>
                                          </label>
                                        </div>`
          );
        })
        .fail(function(){
          alert('カテゴリー取得に失敗しました');
        });
      }
    });
    // 子カテゴリー選択後のイベント
    $('.sell-container__content__details').on('change', '#genre-select-children', function(){
      let childrenGenreId = $(this).val();
      //選択された子カテゴリーのIDを取得
      if (childrenGenreId == ''){
        //子カテゴリーが空（初期値）の時
        $('#select-grandchildren-box').remove(); 
        //孫以下を削除する
      }else{
        $.ajax({
          url: '/items/genre_grandchildren',
          type: 'GET',
          data: { child_id: childrenGenreId },
          dataType: 'json'
        })
        .done(function(genre_grandchildren){
          $('#select-grandchildren-box').remove();
          //子が変更された時、孫を削除する
          let optionHtml = '';
          genre_grandchildren.forEach(function(grandchildren){
            optionHtml += genreOption(grandchildren);
            //option要素を作成する
          });
          $('#error-genre').before(`<div class="sell-collection_select " id="select-grandchildren-box">
                                          <label class="sell-collection_select__label" for="item_genre_id">
                                            <select class="sell-collection_select__input" id="genre-select-grandchildren" required="required" name="item[genre_id]">
                                              <option value="">選択して下さい</option>
                                              ${optionHtml}
                                            </select>
                                            <i class="fas fa-chevron-down"></i>
                                          </label>
                                        </div>`
          );
        })
        .fail(function(){
          alert('カテゴリー取得に失敗しました');
        });
      }
    });
  });


  // 各フォームの入力チェック
  $(function(){
    //画像
    $('#image-input').on('focus',function(){
      $('#error-image').text('');
      $('#image-input').on('blur',function(){
        $('#error-image').text('');
        let imageLength = $('#output-box').children('h1').length;
        if(imageLength ==''){
          $('#error-image').text('画像がありません');
        }else if(imageLength >10){
          $('#error-image').text('画像を10枚以下にして下さい');
        }else{
          $('#error-image').text('');
        }
      });
    });

    //送信しようとした時
    $('#form').on('submit',function(e){
      e.preventDefault();
      let imageLength = $('#output-box').children('h1').length;
      if(imageLength ==''){
        $('body, html').animate({ scrollTop: 0 }, 500);
        $('#error-image').text('画像がありません');
        return false;
      }else if(imageLength >10){
        $('body, html').animate({ scrollTop: 0 }, 500);
        $('#error-image').text('画像を10枚以下にして下さい');
        return false;
      }else{
        return true;
      }
    });

     //画像を削除した時
    $(document).on('click','.preview-image__button__delete',function(){
      let imageLength = $('#output-box').children('h1').length;
      if(imageLength ==''){
        $('#error-image').text('画像がありません');
      }else if(imageLength >10){
        $('#error-image').text('画像を10枚以下にして下さい');
      }else{
        $('#error-image').text('');
      }
    });

    //商品名
    $('.sell-container__content__name').on('blur',function(){
      let value = $(this).val();
      if(value == ""){
        $('#error-name').text('入力してください');
        $(this).css('border-color','red');
      }else{
        $('#error-name').text('');
        $(this).css('border-color','rgb(204, 204, 204)');
      }
    });

    //商品説明
    $('.sell-container__content__description').on('blur',function(){
      let value = $(this).val();
      if(value == ""){
        $('#error-text').text('入力してください');
        $(this).css('border-color','red');
      }else{
        $('#error-text').text('');
        $(this).css('border-color','rgb(204, 204, 204)');
      }
    });

    //ジャンルのエラーハンドリング
    function genreError(genreSelect){
      let value = $(genreSelect).val();
      if(value == ""){
        $('#error-genre').text('選択して下さい');
        $(genreSelect).css('border-color','red');
      }else{
        $('#error-genre').text('');
        $(genreSelect).css('border-color','rgb(204, 204, 204)');
      }
    };
    //親カテゴリー
    $('#genre-select-parent').on('blur',function(){
      genreError('#genre-select-parent')
    });
    //子カテゴリー
    $('.sell-container__content__details').on('blur', '#genre-select-children', function(){
      genreError('#genre-select-children')
    });
    //孫カテゴリー
    $('.sell-container__content__details').on('blur', '#genre-select-grandchildren', function(){
      genreError('#genre-select-grandchildren')
    });

    //ブランド
    $('sell-container__content__brand').on('blur',function(){
      let value = $(this).val();
    });
    

    //状態
    $('#condition-select').on('blur',function(){
      let value = $(this).val();
      if(value == ""){
        $('#error-condition').text('選択して下さい');
        $(this).css('border-color','red');
      }else{
        $('#error-condition').text('');
        $(this).css('border-color','rgb(204, 204, 204)');
      }
    });

    //送料負担
    $('#delivery_fee-select').on('blur',function(){
      let value = $(this).val();
      if(value == ""){
        $('#error-delivery_fee').text('選択して下さい');
        $(this).css('border-color','red');
      }else{
        $('#error-delivery_fee').text('');
        $(this).css('border-color','rgb(204, 204, 204)');
      }
    });

    //発送元
    $('#pref-select').on('blur',function(){
      let value = $(this).val();
      if(value == ""){
        $('#error-pref').text('選択して下さい');
        $(this).css('border-color','red');
      }else{
        $('#error-pref').text('');
        $(this).css('border-color','rgb(204, 204, 204)');
      }
    });

    //発送までの日数
    $('#day-select').on('blur',function(){
      let value = $(this).val();
      if(value == ""){
        $('#error-day').text('選択して下さい');
        $(this).css('border-color','red');
      }else{
        $('#error-day').text('');
        $(this).css('border-color','rgb(204, 204, 204)');
      }
    });

    //価格
    $('.sell-container__content__price__form__box').on('blur',function(){
      let value = $(this).val();
      if(value < 300 || value > 9999999){
        $('#error-price').text('300以上9999999以下で入力してください');
        $(this).css('border-color','red');
      }else{
        $('#error-price').text('');
        $(this).css('border-color','rgb(204, 204, 204)');
      }
    });
  });  
});