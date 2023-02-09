--圣光飞龙
function c27819000.initial_effect(c)
	--disable 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetCost(c27819000.accost)
	e1:SetTarget(c27819000.actg)
	e1:SetOperation(c27819000.acop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
end
c27819000.SetCard_XXLight=true  
c27819000.SetCard_XXLightDragon=true 
function c27819000.accost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,Duel.GetLP(tp)/2) end 
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2) 
end 
function c27819000.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c27819000.chainlm)
end
function c27819000.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
function c27819000.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetTargetRange(0,1)
		e3:SetValue(0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end 
	if c:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(27819000,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY) 
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1) 
	if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()<=PHASE_STANDBY then 
	e1:SetCondition(c27819000.bocon1) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	else 
	e1:SetCondition(c27819000.bocon2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	end 
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetTarget(c27819000.botg)  
	e1:SetOperation(c27819000.boop)  
	c:RegisterEffect(e1)
	end 
end
function c27819000.bocon1(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetLabel()==Duel.GetTurnCount() 
end 
function c27819000.bocon2(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetLabel()~=Duel.GetTurnCount() 
end 
function c27819000.botg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end  
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	g:AddCard(e:GetHandler()) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end  
function c27819000.boop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	g:AddCard(e:GetHandler())  
	local dg=g:Filter(Card.IsOnField,nil)
	Duel.HintSelection(dg) 
	Duel.Destroy(dg) 
end 




