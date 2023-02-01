--圣光飞龙-耀光龙
function c27819045.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(c27819045.mfilter),1) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819045,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,27819045)
	e1:SetCost(c27819045.immcost)
	e1:SetOperation(c27819045.immop)
	c:RegisterEffect(e1) 
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c27819045.atkop)
	c:RegisterEffect(e2) 
	--down 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27819045,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,17819045)
	e3:SetTarget(c27819045.dntg)
	e3:SetOperation(c27819045.dnop)
	c:RegisterEffect(e3) 
end
c27819045.SetCard_XXLight=true 
c27819045.SetCard_XXLightDragon=true 
function c27819045.mfilter(c) 
	return c.SetCard_XXLight and c:IsSynchroType(TYPE_SYNCHRO)  
end 
function c27819045.cfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c27819045.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819045.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c27819045.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c27819045.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c27819045.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c27819045.efilter(e,re)
	return re:GetOwner()~=e:GetOwner()
end
function c27819045.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	if rp==1-tp and re:IsActiveType(TYPE_MONSTER) and c:GetFlagEffect(1)>0 then 
	Duel.Hint(HINT_CARD,0,27819045) 
		if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetRange(LOCATION_MZONE)  
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		tc=g:GetNext()  
		end 
		else 
		Duel.Damage(1-tp,500,REASON_EFFECT) 
		end 
	end 
end 
function c27819045.ckfil(c) 
	return c:IsFaceup() and c.SetCard_XXLight	 
end 
function c27819045.dntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c27819045.ckfil,tp,LOCATION_MZONE,0,1,nil) end  
end 
function c27819045.dnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	local g2=Duel.GetMatchingGroup(c27819045.ckfil,tp,LOCATION_MZONE,0,nil) 
	if g1:GetCount()>0 and g2:GetCount()>0 then 
	local tc=g1:GetFirst() 
	while tc do 
	local pratk=tc:GetAttack()
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE)   
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetValue(-500*g2:GetCount()) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1)  
	if pratk~=0 and tc:GetAttack()==0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Destroy(tc,REASON_EFFECT) 
	end 
	tc=g1:GetNext()  
	end 
	end 
end 











