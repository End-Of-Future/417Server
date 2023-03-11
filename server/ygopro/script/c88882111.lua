--超高校级•护士
function c88882111.initial_effect(c) 
	c:SetSPSummonOnce(88882111)
	--link summon
	aux.AddLinkProcedure(c,c88882111.matfilter,1,1)
	c:EnableReviveLimit()
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e1:SetTarget(c88882111.mvtg)
	e1:SetOperation(c88882111.mvop)
	c:RegisterEffect(e1) 
	--immuse
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_IMMUNE_EFFECT) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(LOCATION_MZONE,0) 
	e2:SetTarget(c88882111.tgtg) 
	e2:SetValue(c88882111.imval)
	c:RegisterEffect(e2) 
	--atk up 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_UPDATE_ATTACK) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c88882111.tgtg)
	e3:SetValue(500)
	c:RegisterEffect(e3) 
end 
c88882111.ACGXJre=true 
function c88882111.matfilter(c) 
	return c.ACGXJre 
end 
function c88882111.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()  
end
function c88882111.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c88882111.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c88882111.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c88882111.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetControl(tc,tp)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		tc:RegisterEffect(e2)  
		if c:IsRelateToEffect(e) then 
		Duel.BreakEffect()  
		Duel.Destroy(c,REASON_EFFECT)   
		end 
	end
end 
function c88882111.clop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	c.ACGXJre=false
	e:Reset() 
end 
function c88882111.imval(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_MONSTER) and not te:GetHandler():IsOnField() 
end 
function c88882111.tgtg(e,c)
	return c:GetMutualLinkedGroupCount()>0 
end











