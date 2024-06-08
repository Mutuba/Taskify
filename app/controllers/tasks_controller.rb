# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(updated_at: :desc)
    @task = Task.new

  end

  def create
    @task = Task.new(task_params)
  
    respond_to do |format|
      if @task.save
        format.turbo_stream { render turbo_stream: turbo_stream.prepend(:tasks, partial: "tasks/task", locals: { task: @task }) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
  

  def toggle
    @task = Task.find(params[:id])
    respond_to do |format|
      if @task.update(completed: params[:completed])
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@task, partial: "tasks/task", locals: { task: @task })
        }
        format.json { render json: { message: "Task was successfully updated"} }
      else
        format.html { redirect_to tasks_url, alert: @task.errors.full_messages.join(", ") }
      end
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    respond_to do |format|
      if @task.update(task_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@task, partial: "tasks/task", locals: { task: @task }) }
        format.json { render json: { message: 'Task was successfully updated' } }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end
  

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@task) }
    end
  end

  private

  def task_params
    params.require(:task).permit(:description)
  end
end
