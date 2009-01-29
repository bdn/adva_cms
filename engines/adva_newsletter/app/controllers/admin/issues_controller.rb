class Admin::IssuesController < Admin::BaseController
  before_filter :set_newsletter, :except => :index

  def index
    @newsletter = Newsletter.all_included.find(params[:newsletter_id])
    @issues = @newsletter.issues
  end

  def show
    @issue = Issue.find(params[:id])
  end

  def new
    @issue = Issue.new
  end

  def edit
    @issue = Issue.find(params[:id])
    if !@issue.editable?
      flash[:error] = t(:"adva.messages.not_editable")
      redirect_to admin_issue_path(@site, @newsletter, @issue)
    end
  end

  def create
    @issue = @newsletter.issues.build(params[:issue])

    if @issue.save
      flash[:notice] = t(:"adva.issue.flash.create_success")
      redirect_to admin_issue_path(@site, @newsletter, @issue)
    else
      render :action => "new"
    end
  end

  def update
    @issue = Issue.find(params[:id])
    
    return cancel_delivery if params[:cancel_delivery]

    if @issue.update_attributes(params[:issue])
      if @issue.draft?
        flash[:notice] = t(:"adva.issue.flash.update_success")
      else
        delivery
      end
      redirect_to admin_issue_path(@site, @newsletter, @issue)
    else
      render :action => "edit"
    end
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    flash[:notice] = t(:"adva.newsletter.flash.issue_moved_to_trash_success")
    redirect_to admin_issues_path(@site, @newsletter)
  end
  
private
  def set_newsletter
    @newsletter = Newsletter.find(params[:newsletter_id])
  end

  def delivery
    if params[:send_now].present?
      @issue.deliver ? flash[:notice] = t(:"adva.issue.flash.send_now") : delivery_start_failed_flash
    elsif params[:send_later].present?
      @issue.deliver(:later_at => params[:publish_at]) ? flash[:notice] = t(:"adva.issue.flash.send_later") : deliver_start_failed_flash
    end
  end
  
  def delivery_start_failed_flash
    flash[:error] = t(:"adva.newsletter.flash.delivery_start_failed")
  end
  
  def cancel_delivery
    if @issue.cancel_delivery
      flash[:notice] = t(:"adva.newsletter.flash.delivery_cancellation_success")
    else
      flash[:error] = t(:"adva.newsletter.flash.delivery_cancellation_failed")
    end
    redirect_to admin_issue_path(@site, @newsletter, @issue)
  end
end
