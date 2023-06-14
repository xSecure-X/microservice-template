# Especificación de prueba para UserCreator
require_relative '../config/environment'
require_relative '../app/models/user.rb'
require_relative '../app/services/user/user_creator.rb'


RSpec.describe UserCreator do
    
    let(:user_params) { { name: 'John Doe', email: 'john.doe@example.com' } }
    let(:user) { double('User') }
  
    subject { described_class.new(user_params) }
  
    describe '#create_user' do
      it 'creates a new user' do
        expect(User).to receive(:create).with(user_params).and_return(user)
        expect(subject.create_user).to eq(user)
      end
    end
  
    describe '#update_user' do
      it 'updates the user with given parameters' do
        expect(user).to receive(:update).with(user_params)
        expect(subject.update_user(user)).to eq(user)
      end
    end
  
    describe '#delete_user' do
      it 'destroys the user' do
        expect(user).to receive(:destroy)
        subject.delete_user(user)
      end
    end
  end
  