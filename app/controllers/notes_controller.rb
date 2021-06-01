class NotesController < ApplicationController
  before_action :set_user
  before_action :set_note, only: [:share_note, :share, :remove_shared_user, :show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @notes = @user.notes
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @shared_users = @note.users.where.not(id: @note.created_user)
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.user_id = @user.id
    respond_to do |format|
      if @note.save
        @user.notes << @note
        format.html { redirect_to user_notes_path(@user, @note), notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to user_notes_path(@user, @note), notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to user_notes_url(@user), notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def share_note
    @share_users = User.where.not(id: @note.users, role: 'admin').map{|u| [u.email, u.id]}
  end

  def share
    if params[:shared_user_id].present?
      shared_user = User.find(params[:shared_user_id])
      @note.users << shared_user unless @note.users.include?(shared_user)
      redirect_to user_notes_path(@user, @note), notice: 'Note was successfully shared.'
    else
      redirect_to user_notes_path(@user, @note), error: 'Invalid to share'
    end
  end

  def remove_shared_user
    if params[:shared_user_id].present?
      shared_user = User.find(params[:shared_user_id])
      byebug
      @note.users.delete(shared_user)
      redirect_to user_notes_path(@user, @note), notice: "Note was successfully take from #{shared_user.email}."
    else
      redirect_to user_notes_path(@user, @note), error: 'Invalid to share'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_note
      @note = @user.notes.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit( :title, :description)
    end
end
