class PoemesController < ApplicationController
  before_action :set_poeme, only: [:show, :edit, :update, :destroy]

  # GET /poemes
  # GET /poemes.json
  def index
    letter = params[:starting_letter]
    if letter.nil?
      @poemes = Poeme.paginate(:page => params[:page], :per_page => 30)
    else
      @letter = letter.to_s.downcase
      @poemes = Poeme.where('title ilike ? or research_name ilike ?', "%#{@letter}%", "%#{@letter}%").order('title').paginate(:page => params[:page], :per_page => 30)
    end
  end

  # GET /poemes/1
  # GET /poemes/1.json
  def show
    @auteur = @poeme.auteur
  end

  # GET /poemes/new
  def new
    @poeme = Poeme.new
  end

  # GET /poemes/1/edit
  def edit
  end

  # POST /poemes
  # POST /poemes.json
  def create
    @poeme = Poeme.new(poeme_params)

    respond_to do |format|
      if @poeme.save
        format.html { redirect_to @poeme, notice: 'Poeme was successfully created.' }
        format.json { render :show, status: :created, location: @poeme }
      else
        format.html { render :new }
        format.json { render json: @poeme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /poemes/1
  # PATCH/PUT /poemes/1.json
  def update
    respond_to do |format|
      if @poeme.update(poeme_params)
        format.html { redirect_to @poeme, notice: 'Poeme was successfully updated.' }
        format.json { render :show, status: :ok, location: @poeme }
      else
        format.html { render :edit }
        format.json { render json: @poeme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /poemes/1
  # DELETE /poemes/1.json
  def destroy
    @poeme.destroy
    respond_to do |format|
      format.html { redirect_to poemes_url, notice: 'Poeme was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poeme
      @poeme = Poeme.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poeme_params
      params.require(:poeme).permit(:title, :content, :recueil, :slug, :written_date, :auteur_id)
    end
end
