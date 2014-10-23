class AuteursController < ApplicationController
  before_action :set_auteur, only: [:show, :edit, :update, :destroy]
  before_filter :no_access, only:[:edit, :new, :create, :destroy]
  # GET /auteurs
  # GET /auteurs.json
  def index
    letter = params[:starting_letter]
    if letter.nil?
      first_letter = params[:first_letter] || "A"
      @auteurs = Auteur.where('auteurs.first_letter ILIKE ?', first_letter).paginate(:page => params[:page], :per_page => 100)
    else
      @letter = letter.to_s.downcase
      @auteurs = Auteur.where('name ilike ? or research_name ilike ?', "%#{@letter}%", "%#{@letter}%").order('name').paginate(:page => params[:page], :per_page => 100)
    end
    
  end

  # GET /auteurs/1
  # GET /auteurs/1.json
  def show
    @poemes = @auteur.poemes.paginate(:page => params[:page], :per_page => 1000)
  end

  # GET /auteurs/new
  def new
    @auteur = Auteur.new
  end

  # GET /auteurs/1/edit
  def edit
  end

  # POST /auteurs
  # POST /auteurs.json
  def create
    @auteur = Auteur.new(auteur_params)

    respond_to do |format|
      if @auteur.save
        format.html { redirect_to @auteur, notice: 'Auteur was successfully created.' }
        format.json { render :show, status: :created, location: @auteur }
      else
        format.html { render :new }
        format.json { render json: @auteur.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auteurs/1
  # PATCH/PUT /auteurs/1.json
  def update
    respond_to do |format|
      if @auteur.update(auteur_params)
        format.html { redirect_to @auteur, notice: 'Auteur was successfully updated.' }
        format.json { render :show, status: :ok, location: @auteur }
      else
        format.html { render :edit }
        format.json { render json: @auteur.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auteurs/1
  # DELETE /auteurs/1.json
  def destroy
    @auteur.destroy
    respond_to do |format|
      format.html { redirect_to auteurs_url, notice: 'Auteur was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_auteur
    @auteur = Auteur.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def auteur_params
    params.require(:auteur).permit(:name, :description, :description_source, :birth_date, :death_date, :poemes_count, :century, :first_letter, :slug, :country)
  end
end
