# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Services::UserCreator do
  let(:user_params) { { name: 'John', email: 'john@example.com' } }
  let(:user) { instance_double(User) }

  subject { described_class.new(user_params) }

  describe '#create_user' do
    it 'creates a new user with the provided parameters' do
      expect(User).to receive(:create).with(user_params).and_return(user)
      expect(subject.create_user).to eq(user)
    end
  end

  describe '#update_user' do
    it 'updates the given user with the provided parameters' do
      expect(user).to receive(:update).with(user_params)
      expect(subject.update_user(user)).to eq(user)
    end
  end

  describe '#delete_user' do
    it 'destroys the given user' do
      expect(user).to receive(:destroy)
      subject.delete_user(user)
    end
  end
end
